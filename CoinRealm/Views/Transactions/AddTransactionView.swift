//
//  AddTransactionView.swift
//  CoinRealm
//
//  Created by J. DeWeese on 11/28/23.
//

import SwiftUI
import RealmSwift

struct AddTransaction: View {
    @EnvironmentObject var appVM: AppViewModel
    @EnvironmentObject var transactionVM: TransactionViewModel
    @Environment(\.dismiss) var dismiss
    
    @FocusState private var amountIsFocused: Bool
    @FocusState private var noteIsFocused: Bool
    @FocusState private var keyIsFocused: Bool
    
    @State var selectedCategory: Category
    @State var amount: Float = 0
    @State var date: Date = Date()
    @State var note: String = ""
    @State var selectedType: CategoryType = .expense
    @State var alertAmount: Bool = false
    @State var alertCategory: Bool = false
    
    private let formatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 2
        formatter.zeroSymbol = ""
        return formatter
    }()
    
    var body: some View {
        NavigationStack {
            ScrollView(.vertical, showsIndicators: false) {
                VStack(alignment: .leading) {
                    Section {
                        TextField(selectedType == .expense ? "-100 \(appVM.currencySymbol)" : "+100 \(appVM.currencySymbol)", value: $amount, formatter: formatter)
                            .font(.title3)
                            .keyboardType(appVM.roundingNumbers ? .numberPad : .decimalPad)
                            .padding()
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                            .background(Color("colorBalanceBG"))
                            .cornerRadius(10)
                            .padding(.bottom, 15)
                            .focused($amountIsFocused)
                    } header: {
                        Text("Enter amount:")
                            .font(.caption).textCase(.uppercase)
                            .padding(.leading, 10)
                    }
                    .onTapGesture {
                        amountIsFocused.toggle()
                    }
                    
                    Section {
                        TextField("Note", text: $note)
                            .padding()
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                            .background(Color("colorBalanceBG"))
                            .cornerRadius(10)
                            .focused($noteIsFocused)
                        
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack {
                                let filterTransaction = transactionVM.filterTransactionsNote(category: selectedCategory, transactions: transactionVM.transactions)
                                ForEach(filterTransaction.reversed(), id: \.self) { notes in
                                    Button {
                                        note = notes.note
                                    } label: {
                                        Text(String(notes.note.prefix(20)))
                                            .font(Font.caption)
                                            .foregroundColor(Color(.systemGray2))
                                            .padding(.vertical, 5)
                                            .padding(.horizontal, 10)
                                            .background(
                                                RoundedRectangle(cornerRadius: 7, style: .continuous)
                                                    .strokeBorder(Color(.systemGray2))
                                            )
                                            .padding(.bottom, 10)
                                    }
                                }
                            }
                            .padding(.horizontal, 10)
                        }
                    } header: {
                        Text("Enter note:")
                            .font(.caption).textCase(.uppercase)
                            .padding(.leading, 10)
                    }
                    .onTapGesture {
                        noteIsFocused.toggle()
                    }
                    Section {
                        Picker("Category type", selection: $selectedType) {
                            ForEach(CategoryType.allCases, id: \.self) { type in
                                Text(type.localizedName())
                            }
                        }
                        .pickerStyle(SegmentedPickerStyle())
                        .padding(10)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .background(Color("colorBalanceBG"))
                        .cornerRadius(10)
                        .onChange(of: selectedType) { _ in
                            withAnimation() {
                                selectedCategory = Category()
                            }
                            
                        }
                    }
                    HStack {
                        NavigationLink(destination: PickerCategoryView( selected: $selectedCategory, selectedType: selectedType), label: {
                            if selectedCategory.name.isEmpty {
                                HStack {
                                    Spacer()
                                    Text("?")
                                        .font(.system(size: 15))
                                        .frame(width: 30, height: 30)
                                        .background {
                                            RoundedRectangle(cornerRadius: 10, style: .circular)
                                                .strokeBorder(Color(Colors.mainText))
                                        }
                                    
                                    Text("Select a category")
                                    Spacer()
                                }
                                .font(Font.subheadline)
                                .padding(10)
                                .frame(maxWidth: .infinity)
                                .background(Color(Colors.colorPickerBG))
                                .cornerRadius(10)
                            } else {
                                HStack {
                                    Text("Category:")
                                        .font(.headline)
                                    Spacer()
                                    Image(systemName: selectedCategory.icon)
                                        .font(.system(size: 15))
                                        .foregroundColor(.black)
                                        .frame(width: 25, height: 25)
                                        .background(Color(selectedCategory.color))
                                        .cornerRadius(7.5)
                                    Text(selectedCategory.name)
                                        .font(.headline)
                                        .fontWeight(.light)
                                }
                                .padding(5)
                            }
                        })
                        .foregroundColor(Color(Colors.mainText))
                        .padding(10)
                        .background(Color(Colors.colorBalanceBG))
                        .cornerRadius(10)
                    }
                }
                
                Section {
                    HStack {
                        DatePicker("Date", selection: $date, displayedComponents: .date)
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    .padding()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(Color("colorBalanceBG"))
                    .cornerRadius(10)
                } header: {
                    Text("Enter date:")
                        .font(.caption).textCase(.uppercase)
                        .padding(.leading, 10)
                        .padding(.top, 10)
                }
            }
            .padding(.horizontal, 15)
            .padding(.top, 20)
            .scrollDismissesKeyboard(.immediately)
            .background(Color("colorBG"))
            .navigationBarTitle("Addendum", displayMode: .inline)
            
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        HapticManager.notification(type: .success)
                        dismiss()
                    } label: {
                        Text("Cancel")
                            .fontDesign(.serif)
                            .font(.title3)
                            .fontWeight(.bold)
                            .foregroundStyle(Color.red)
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        if amount == 0 {
                            alertAmount = true
                        } else if selectedCategory.name == "" {
                            alertCategory = true
                        } else if selectedType != selectedCategory.type {
                            alertCategory = true
                            selectedCategory = Category()
                        } else {
                            HapticManager.notification(type: .success)
                            transactionVM.saveTransaction(amount: amount, date: date, note: note, type: selectedType, category: selectedCategory)
                            dismiss()
                        }
                    } label: {
                        Text("Save")
                            .fontDesign(.serif)
                            .font(.title3)
                            .fontWeight(.bold)
                            .foregroundStyle(Color.green)
                    }
                    .alert("Please select a category", isPresented: $alertCategory) {
                        Button("Okay", role: .cancel) { }
                    }
                    .alert("Please enter amount", isPresented: $alertAmount) {
                        Button("Okay", role: .cancel) { }
                    }
                }
            }
        }
    }
}
struct AddTransaction_Previews: PreviewProvider {
    static var previews: some View {
        AddTransaction(selectedCategory: Category())
            .environmentObject(AppViewModel())
            .environmentObject(TransactionViewModel())
    }
}
