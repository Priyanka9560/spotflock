

import UIKit

class ParserStruct {

struct structLoginAndRegister {
    var name = ""
    var email = ""
    var password = ""
    var password_confirmation = ""
    var mobile = ""
    var gender = ""
}

struct dashboardStruct {
    var id : Int = 0
    var rss_source_id : Int = 0
    var title : String = ""
    var title_image : String = ""
    var tag_line : String = ""
    var short_description : String = ""
    var full_description : String = ""
    var title_image_url : String = ""
    var description_image_url : String = ""
    var article_url : String = ""
    var author : String = ""
    var article_type : String = ""
    var published_date : String = ""
    var is_sponsored : Bool = false
    var is_premium : Bool = false
    var tags : String = ""
    var filtertags : String = ""
    var likes : Int = 0
    var comments : Int = 0
    var shares : Int = 0
    var accepted: Bool = false
    var meta_kstream_id : String = ""
    var accepteda : String = ""
    var created_at : String = ""
    var updated_at : String = ""

}
}

//class structFeeds
//{
//    var strHeading = ""
//    var strSub_heading = ""
//    var strType = ""
//    var strData = ""
//}
