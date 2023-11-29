//
//  TransactionViewModel.swift
//  CoinRealm
//
//  Created by J. DeWeese on 11/28/23.
//

import Foundation
import RealmSwift

final class TransactionViewModel: ObservableObject {
    @Published var transactions: [TransactionItem] = []
    
    init() {
        loadData()
    }
    
  //MARK:  LOAD DATA - TRANSACTIONS -
    func loadData() {
        guard let realm = try? Realm() else {
            print("TRANSACTION: loadData")
            return
        }
        let transactionsResult = realm.objects(TransactionItem.self)
        transactions = Array(transactionsResult)
    }
    
    //MARK:  SAVE DATA - TRANSACTIONS -
    func saveTransaction(amount: Float, date: Date, note: String, type: CategoryType, category: Category) {
        guard let realm = try? Realm() else {
            print("Ошибка: Не удалось создать экземпляр Realm")
            return
        }
        if let newCategory = realm.object(ofType: Category.self, forPrimaryKey: category.id) {
            let newTransaction = TransactionItem()
            newTransaction.categoryId = newCategory.id
            newTransaction.amount = amount
            newTransaction.date = date
            newTransaction.note = note
            newTransaction.type = type
            do {
                try realm.write {
                    newCategory.transactions.append(newTransaction)
                }
                
               //UPDATE
                transactions.append(newTransaction)
                
               
                print("TRANSACTION UPDATED \(newTransaction)")
            } catch {
                
                print("Unable to update transaction \(error)")
            }
        } else {
           
            print("transaction updated ")
        }
    }
    
   //DELETE TRANSACTION
    private func deleteTransaction(withId id: ObjectId) {
        do {
            let realm = try Realm()
            
            if let transaction = realm.object(ofType: TransactionItem.self, forPrimaryKey: id) {
                try realm.write {
                    if let category = transaction.category.first {
                        if let index = category.transactions.firstIndex(of: transaction) {
                            category.transactions.remove(at: index)
                        }
                    }
                    realm.delete(transaction)
                }
                loadData()
            } else {
                print("TRANSACTION ID \(id) ")
            }
        } catch let error {
            print("UNABLE TO DELETE TRANSACTION: \(error)")
        }
    }
    

    func deleteTransaction(at offsets: IndexSet, from sortedTransactions: [TransactionItem]) {
        offsets.forEach { index in
            let transaction = sortedTransactions[index]
            deleteTransaction(withId: transaction.id)
        }
    }
    
    // MARK: TransactionView
   
    func transactionsByDate(_ transactions: [TransactionItem]) -> [Date: [TransactionItem]] {
        var groupedTransactions: [Date: [TransactionItem]] = [:]
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none
        
        for transaction in transactions {
            let dateString = dateFormatter.string(from: transaction.date)
            if let date = dateFormatter.date(from: dateString) {
                if groupedTransactions[date] == nil {
                    groupedTransactions[date] = []
                }
                groupedTransactions[date]?.append(transaction)
            }
        }
        
        return groupedTransactions
    }
    
   //FILTER
    func filterCategories(categories: [Category], transaction: TransactionItem) -> Category? {
        for category in categories {
            if category.id == transaction.categoryId {
                return category
            }
        }
        return nil
    }
    
   
    func sortTransactionsByDate(transactions: [TransactionItem]) -> [TransactionItem] {
        return transactions.sorted(by: { $0.date > $1.date })
    }
    
    // MARK: TransactionCategoryView
   
    func filterTransaction(category: Category, transactions: [TransactionItem]) -> [TransactionItem] {
        var groupedTransaction: [TransactionItem] = []
        
        for transaction in transactions {
            if category.id == transaction.categoryId {
                groupedTransaction.append(transaction)
            }
        }
        return groupedTransaction
    }
    
    // MARK: AddTransactionView
  
    func filterTransactionsNote(category: Category, transactions: [TransactionItem]) -> [TransactionItem] {
        var groupedTransaction: [TransactionItem] = []
        var uniqueNotes: [String] = []
        
            for transaction in transactions.prefix(20) {
                if category.id == transaction.categoryId {
                if transaction.note.count != 0 {
                    if !uniqueNotes.contains(transaction.note.description) {
                        uniqueNotes.append(transaction.note.description)
                        groupedTransaction.append(transaction)
                    }
                }
            }
        }
        return groupedTransaction
    }
    
    // MARK: HomeView
  
    func totalExpenses() -> Float {
        var expenses: Float = 0
        for transaction in transactions {
            if transaction.type == .expense {
                expenses += transaction.amount
            }
        }
        return expenses
    }
    
    //MARK:  TOTAL INCOME 
    func totalIncomes() -> Float {
        var icncome: Float = 0
        for transaction in transactions {
            if transaction.type == .income {
                icncome += transaction.amount
            }
        }
        return icncome
    }
    
    
    func balance() -> Float {
        return totalIncomes() - totalExpenses()
    }
    
    //MARK:  AVERAGE DAILY EXPENSE BY DOLLAR
    func averageDailyExpense() -> Float {
        let expenseTransactions = transactions.filter { $0.type == .expense }
        guard !expenseTransactions.isEmpty else {
            return 0
        }
        
        let uniqueExpenseDates = Set(expenseTransactions.map { transaction -> Date in
            let calendar = Calendar.current
            let components = calendar.dateComponents([.year, .month, .day], from: transaction.date)
            return calendar.date(from: components) ?? transaction.date
        })
        
        let daysWithTransactions = uniqueExpenseDates.count
        
        let totalExpenseAmount = totalExpenses()
        
        return totalExpenseAmount / Float(daysWithTransactions)
    }
}

