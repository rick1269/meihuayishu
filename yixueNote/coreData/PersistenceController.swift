import CoreData

struct PersistenceController {
	static let shared = PersistenceController()

	let container: NSPersistentContainer

	init(inMemory: Bool = false) {
		container = NSPersistentContainer(name: "易学笔记") // 替换为你的数据模型文件名
		if inMemory {
			container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
		}
		container.loadPersistentStores { (storeDescription, error) in
			if let error = error {
				fatalError("Error loading Core Data stores: \(error)")
			}
		}
	}

	func saveContext() {
		let context = container.viewContext
		if context.hasChanges {
			do {
				try context.save()
			} catch {
				let nsError = error as NSError
				fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
			}
		}
	}
}
