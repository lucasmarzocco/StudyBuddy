

import UIKit

class PlayerCell: UITableViewCell {
  
  @IBOutlet weak var gameLabel: UILabel!
  @IBOutlet weak var nameLabel: UILabel!
  
  var player: Player! {
    didSet {
      gameLabel.text = player.game
      nameLabel.text = player.name
    }
  }

  
  
}
