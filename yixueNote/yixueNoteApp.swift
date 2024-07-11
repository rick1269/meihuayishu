import SwiftUI
import CoreData

@main
struct yixueNoteApp: App {
	let persistenceController = PersistenceController.shared

	var body: some Scene {
		WindowGroup {
			FirstPageView()
				.environment(\.managedObjectContext, persistenceController.container.viewContext)
		}
	}
}

