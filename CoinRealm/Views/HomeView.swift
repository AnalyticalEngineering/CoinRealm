//
//  HomeView.swift
//  CoinRealm
//
//  Created by J. DeWeese on 11/28/23.
//

    import SwiftUI
    import RealmSwift

struct HomeView: View {
    //MARK:   PROPERTIES
    @EnvironmentObject var appVM: AppViewModel
    @EnvironmentObject var categoryVM: CategoryViewModel
    @EnvironmentObject var transactionVM: TransactionViewModel
    @ObservedResults(Category.self) var categories
    @State private var showSideMenu: Bool = false
    @State private var showAddTransaction: Bool = false
    @State private var selectedCategoryType: CategoryType = .expense
    //Adaptive  Grid size
    private let adaptive =
    [
        GridItem(.adaptive(minimum: 165))
    ]
    
    var body: some View {
        
        
        NavigationStack {
            ZStack(alignment: Alignment(horizontal: .trailing, vertical: .bottom))  {
                //MARK:  LAZY GRID - BALANACE SCORE CARDS
                ScrollView(.vertical, showsIndicators: false) {
                    LazyVGrid(columns: adaptive  ){
                        
                        BalanceView(amount: transactionVM.balance(), curren: appVM.currencySymbol, type: NSLocalizedString("Balance", comment: "Balance"), icon: "equal.circle", iconBG: Color(Colors.colorBlue))
                        
                        BalanceView(amount: transactionVM.averageDailyExpense(), curren: appVM.currencySymbol, type: NSLocalizedString("Expense average", comment: "Expense average"), icon: "plusminus.circle", iconBG: Color(Colors.colorYellow))
                        
                        BalanceView(amount: transactionVM.totalIncomes(), curren: appVM.currencySymbol, type: NSLocalizedString("Income", comment: "Income"), icon: "plus.circle", iconBG: Color(Colors.colorGreen))
                        
                        BalanceView(amount: transactionVM.totalExpenses(), curren: appVM.currencySymbol, type: NSLocalizedString("Expense", comment: "Expense"), icon: "minus.circle", iconBG: Color(Colors.colorRed))
                        
                    }
                    .padding(.horizontal)
                    .padding(.top)
                    
                    //MARK:  CATEGORY TYPE PICKER (EXPENSE/INCOME)
                    Picker("Type:", selection: $selectedCategoryType) {
                        ForEach(CategoryType.allCases, id: \.self) { type in
                            Text(type.localizedName())
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    .padding(10)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(Color(Colors.colorBalanceBG))
                    .cornerRadius(10)
                    .padding(.horizontal, 15)
                }
                
                let categoriesWithTransactionsArray = categoryVM.categoriesWithTransaction(categories: categories, type: selectedCategoryType)
                
                
                var filteredCategoriesArray =  categoryVM.filteredCategories(categories: categoriesWithTransactionsArray, type: selectedCategoryType)
                
                
                let _: () = filteredCategoriesArray.sort(by: { $0.categoryAmount(type: selectedCategoryType) > $1.categoryAmount(type: selectedCategoryType)})
                
                if filteredCategoriesArray.isEmpty {
                    previewHomeTransaction()
                } else {
                    
                    ForEach(filteredCategoriesArray, id: \.self) { category in
                        let totalAmount = category.categoryAmount(type: selectedCategoryType)
                        NavigationLink(destination: TransactionCategoryView()) {
                            
                            CategoryItemView(categoryColor: category.color, categoryIcon: category.icon, categoryName: category.name, totalAmount: totalAmount, currencySymbol: appVM.currencySymbol)
                        }
                    }
                }
            }
            .cornerRadius(10)
            .padding(.horizontal, 15)
            .padding(.bottom, 100)
            //    MARK:  TOOL BAR - SIDE MENU AND ADD BUDGET/CATEGORY
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        HapticManager.notification(type: .success)
                    } label: {
                        NavigationLink(destination: SettingsView(), label: {
                            Button {
                                HapticManager.notification(type: .success)
                                showAddTransaction.toggle()
                            } label: {
                                HStack{
                                    Text("Add Expense")
                                        .fontDesign(.serif)
                                        .font(.system(size:16))
                                        .fontWeight(.semibold)
                                        .foregroundStyle(Color("colorBalanceText"))
                                    ZStack {
                                        Circle()
                                            .frame(width: 30,  height:30)
                                            .foregroundColor(Color("colorBalanceText"))
                                        Image(systemName: "plus")
                                            .foregroundColor(Color("colorBG"))
                                            .fontWeight(.semibold)
                                            .font(.system(size: 13))
                                    }
                                }
                            }
                            .padding(.horizontal)
                        })
                    }
                }
            }
            .toolbar{
                ToolbarItem(placement: .navigationBarLeading) {
                    HStack{
                        Text("Atomic")
                            .fontDesign(.serif)
                            .font(.system(size: 16))
                            .foregroundStyle(Color("colorBalanceText"))
                            .fontWeight(.semibold)
                        Image("prologo")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 27, height: 27)
                        Text("iBudget")
                            .fontDesign(.serif)
                            .font(.system(size:16))
                            .foregroundStyle(Color("colorBalanceText"))
                            .fontWeight(.semibold)
                    }
                }
            }
            
            .sheet(isPresented: $showAddTransaction) {
                AddTransaction(selectedCategory: Category(), selectedType: selectedCategoryType)
            }
        }
    }
}
struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
            .environmentObject(AppViewModel())
            .environmentObject(TransactionViewModel())
            .environmentObject(CategoryViewModel())
    }
}
