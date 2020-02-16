
import Foundation
    struct audioResponse:Decodable{
        var results:[alternatives]
    }
    struct alternatives:Decodable {
        var wordsRequest:words
        var transcriptRequest:transcript
    }
    struct words:Decodable {
        var wordRequest:[singleWord]
    }
    struct transcript:Decodable {
        var trans : String
    }
    struct singleWord : Decodable {
        var word : String
        var startTime : String
        var endTime : String
    }
