import UIKit

class DetailTableViewCell: UITableViewCell {
    
    var background: UIView!
    var mainImageView: UIImageView!
    var titleLabel: UILabel!
    var posterNameLabel: UILabel!
    var interestedLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        for subview in self.subviews {
            subview.removeFromSuperview()
        }
        
    }
    //set this up
}
