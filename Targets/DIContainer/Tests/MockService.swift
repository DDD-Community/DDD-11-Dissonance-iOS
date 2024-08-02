protocol MockServiceType {
  var actionCalled: Bool { get }
  
  func performAction()
}

final class MockService: MockServiceType {
  
  // MARK: - Properties
  private(set) var actionCalled: Bool = false
  
  // MARK: - Methods
  func performAction() {
    actionCalled = true
  }
}
