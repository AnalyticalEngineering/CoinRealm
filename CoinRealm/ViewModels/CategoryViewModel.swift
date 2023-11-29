//
//  CategoryViewModel.swift
//  CoinRealm
//
//  Created by J. DeWeese on 11/28/23.
//

import Foundation
import RealmSwift

final class CategoryViewModel: ObservableObject {
//MARK:  PROPERTIES
  
    @Published var categories: [Category] = []
    
    init() {
        loadData()
    }

//MARK:  LOAD DATA
    func loadData() {
        guard let realm = try? Realm() else {
            print("Ошибка: loadData")
            return
        }
        let categoriesResult = realm.objects(Category.self)
        categories = Array(categoriesResult)
    }
//MARK:  CREATE DEFAULT  CATEGORIES FOR USER
    func createDefaultCategories() {
        guard let realm = try? Realm() else {
            print("Ошибка: Не удалось создать категории по умолчанию Realm")
            return
        }
        
        let defaultCategory = defaultCategoriesModel
        
        try! realm.write {
            for category in defaultCategory {
                realm.add(category)
            }
        }
    }
    //MARK:  SAVE BUDGET CATEGORIES
    func saveCategory(name: String, icon: String, color: String, type: CategoryType) {
        guard let realm = try? Realm() else {
            print("Ошибка: Не удалось создать экземпляр Realm")
            return
        }
        let newCategory = Category()
        newCategory.name = name
        newCategory.icon = icon
        newCategory.color = color
        newCategory.type = type
        do {
            try realm.write {
                realm.add(newCategory)
            }
            // отладочное сообщение
            return print("Категория сохранена: \(newCategory)")
        } catch {
            // отладочное сообщение
            return print("Ошибка сохранения категории: \(error)")
        }
    }
    //MARK:  DELETE CATEGORIES
    func deleteCategory(id: ObjectId) {
        do {
            let realm = try Realm()
            if let category = realm.object(ofType: Category.self, forPrimaryKey: id) {
                try realm.write {
                   
                    for transaction in category.transactions {
                        realm.delete(transaction)
                    }
                    
                 
                    realm.delete(category)
                }
                loadData()
            }
        } catch {
            print("Error deleting category: \(error)")
        }
    }
    // MARK: HOME VIEW 
    
    func filteredCategories(categories: [Category], type: CategoryType) -> [Category] {
        var result: [Category] = []
        for category in categories {
            if category.categoryAmount(type: type) > 0 {
                result.append(category)
            }
        }
        return result
    }
    
    
    func categoriesWithTransaction(categories: Results<Category>, type: CategoryType) -> [Category] {
        var result: [Category] = []
        for category in categories {
            if category.hasTransactions(type: type) {
                result.append(category)
            }
        }
        return result
    }
    
    // MARK: CategoryView
    func filteredCategory(category: Results<Category>, type: CategoryType) -> [Category] {
        return category.filter { $0.type == type
        }
    }
    
    func deleteCategories(category: Results<Category>, at offsets: IndexSet, type: CategoryType, transaction: TransactionViewModel) {
        let filtered = filteredCategory(category: category, type: type)
        offsets.forEach { index in
            deleteCategory(id: filtered[index].id)
            loadData()
            transaction.loadData()
        }
    }
}
