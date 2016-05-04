import UIKit

class PlayerDetailsViewController: UITableViewController {
  
  var player:Player?
  
  var game:String = "ECE 101" {
    didSet {
      detailLabel.text? = game
    }
  }
  
  @IBOutlet weak var nameTextField: UITextField!
  @IBOutlet weak var detailLabel: UILabel!
  
  required init?(coder aDecoder: NSCoder) {
    print("init PlayerDetailsViewController")
    super.init(coder: aDecoder)
  }
  
  deinit {
    print("deinit PlayerDetailsViewController")
  }
  
  override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    if indexPath.section == 0 {
      nameTextField.becomeFirstResponder()
    }
  }
  
  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    if segue.identifier == "SavePlayerDetail" {
      player = Player(name: nameTextField.text, game:game)
    }
    if segue.identifier == "PickGame" {
      if let gamePickerViewController = segue.destinationViewController as? GamePickerViewController {
        gamePickerViewController.selectedGame = game
      }
    }
  }
  
  //Unwind segue
  @IBAction func unwindWithSelectedGame(segue:UIStoryboardSegue) {
    if let gamePickerViewController = segue.sourceViewController as? GamePickerViewController,
      selectedGame = gamePickerViewController.selectedGame {
        game = selectedGame
    }
  }
  
}
