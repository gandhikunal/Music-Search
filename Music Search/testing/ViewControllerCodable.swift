////: Playground - noun: a place where people can play
//
//import Foundation
//
//struct Results: Decodable {
//    let tracks: [Track]
//    
//    init(tracks: [Track]) {
//        self.tracks = tracks
//    }
//    
//    enum CodingKeys: String, CodingKey {
//        case results
//    }
//    
//    enum ResultsCodingKeys: String, CodingKey {
//        case songs
//    }
//    
//    enum SongsCodingKeys: String, CodingKey {
//        case data
//    }
//    
//    init(from decoder: Decoder) throws {
//        let container = try decoder.container(
//            keyedBy: CodingKeys.self)
//        
//        let results = try container.nestedContainer(keyedBy: ResultsCodingKeys.self, forKey: .results)
//        let songs = try results.nestedContainer(keyedBy: SongsCodingKeys.self, forKey: .songs)
//        let data = try songs.decode([Track].self, forKey: .data)
//        
//        self.init(tracks: data)
//    }
//}
//
//struct Track: Decodable {
//    let name: String
//    let artistName: String
//    
//    init(name: String, artistName: String) {
//        self.name = name
//        self.artistName = artistName
//    }
//    
//    enum CodingKeys: String, CodingKey {
//        case attributes
//    }
//    
//    enum NextCodingKeys: String, CodingKey {
//        case name
//        case artistName
//    }
//    
//    init(from decoder: Decoder) throws {
//        let container = try decoder.container(keyedBy: CodingKeys.self)
//        
//        let attributes = try container.nestedContainer(keyedBy: NextCodingKeys.self, forKey: .attributes)
//        let name = try attributes.decode(String.self, forKey: .name)
//        let artistName = try attributes.decode(String.self, forKey: .artistName)
//        
//        self.init(name: name, artistName: artistName)
//    }
//}
//
//
//////////// - Call sites
//
//let jsonString = """
//{"results":{"songs":{"href":"/v1/catalog/us/search?term=kunal&types=songs","next":"/v1/catalog/us/search?offset=5&term=kunal&types=songs","data":[{"id":"673594553","type":"songs","href":"/v1/catalog/us/songs/673594553","attributes":{"previews":[{"url":"https://audio-ssl.itunes.apple.com/apple-assets-us-std-000001/AudioPreview71/v4/f5/f1/6d/f5f16d72-94fd-b89c-c1da-a9ec8459590d/mzaf_8480860462246007000.plus.aac.p.m4a"}],"artwork":{"width":1400,"height":1400,"url":"https://is5-ssl.mzstatic.com/image/thumb/Music/v4/a8/8f/99/a88f9970-4ad5-d903-32ac-d1dc68596c5e/source/{w}x{h}bb.jpeg","bgColor":"fba559","textColor1":"0f0c04","textColor2":"412215","textColor3":"3e2a15","textColor4":"663c22"},"artistName":"Kunal, Shaan, Pravin Mani & KK","url":"https://itunes.apple.com/us/album/o-humdum-suniyo-re/673594500?i=673594553","discNumber":1,"genreNames":["Bollywood","Music","Indian","Soundtrack"],"durationInMillis":237740,"releaseDate":"1994-12-31","name":"O Humdum Suniyo Re","isrc":"INY090200019","albumName":"Saathiya (Original Motion Picture Soundtrack)","playParams":{"id":"673594553","kind":"song"},"trackNumber":5,"composerName":"A. R. Rahman"}},{"id":"673594560","type":"songs","href":"/v1/catalog/us/songs/673594560","attributes":{"previews":[{"url":"https://audio-ssl.itunes.apple.com/apple-assets-us-std-000001/AudioPreview71/v4/a0/de/d3/a0ded3b5-4afa-26b3-c55d-57328e17e8f9/mzaf_85390896006617267.plus.aac.p.m4a"}],"artwork":{"width":1400,"height":1400,"url":"https://is5-ssl.mzstatic.com/image/thumb/Music/v4/a8/8f/99/a88f9970-4ad5-d903-32ac-d1dc68596c5e/source/{w}x{h}bb.jpeg","bgColor":"fba559","textColor1":"0f0c04","textColor2":"412215","textColor3":"3e2a15","textColor4":"663c22"},"artistName":"Srinivas, KK, Kunal & Shaan","url":"https://itunes.apple.com/us/album/mangalayam/673594500?i=673594560","discNumber":1,"genreNames":["Bollywood","Music","Indian","Soundtrack"],"durationInMillis":104281,"releaseDate":"2002-10-18","name":"Mangalayam","isrc":"INY090200022","albumName":"Saathiya (Original Motion Picture Soundtrack)","playParams":{"id":"673594560","kind":"song"},"trackNumber":8,"composerName":"A. R. Rahman"}},{"id":"1154239655","type":"songs","href":"/v1/catalog/us/songs/1154239655","attributes":{"previews":[{"url":"https://audio-ssl.itunes.apple.com/apple-assets-us-std-000001/AudioPreview62/v4/1b/72/fc/1b72fc2f-bca9-cb31-5a5d-9fce163fdfda/mzaf_2671500077676982988.plus.aac.p.m4a"}],"artwork":{"width":1500,"height":1500,"url":"https://is5-ssl.mzstatic.com/image/thumb/Music62/v4/b1/55/7a/b1557a58-fff7-89f0-3615-d53f2549f911/source/{w}x{h}bb.jpeg","bgColor":"42296e","textColor1":"ffffff","textColor2":"f4d631","textColor3":"d9d4e1","textColor4":"d1b33d"},"artistName":"Justin Timberlake, Anna Kendrick, Gwen Stefani, James Corden, Zooey Deschanel, Ron Funches, Caroline Hjelt, Aino Jawo, Christopher Mintz-Plasse & Kunal Nayyar","url":"https://itunes.apple.com/us/album/cant-stop-the-feeling-film-version/1154238159?i=1154239655","discNumber":1,"genreNames":["Soundtrack","Music","Pop","Children's Music"],"durationInMillis":237400,"releaseDate":"2016-09-23","name":"Can't Stop the Feeling! (Film Version)","isrc":"USRC11601599","albumName":"Trolls (Original Motion Picture Soundtrack)","playParams":{"id":"1154239655","kind":"song"},"trackNumber":10,"composerName":"N/A"}},{"id":"1154239514","type":"songs","href":"/v1/catalog/us/songs/1154239514","attributes":{"previews":[{"url":"https://audio-ssl.itunes.apple.com/apple-assets-us-std-000001/AudioPreview62/v4/c9/72/34/c9723405-d365-766e-90d2-5d05faae6c5d/mzaf_2809895643550790977.plus.aac.p.m4a"}],"artwork":{"width":1500,"height":1500,"url":"https://is5-ssl.mzstatic.com/image/thumb/Music62/v4/b1/55/7a/b1557a58-fff7-89f0-3615-d53f2549f911/source/{w}x{h}bb.jpeg","bgColor":"42296e","textColor1":"ffffff","textColor2":"f4d631","textColor3":"d9d4e1","textColor4":"d1b33d"},"artistName":"Zooey Deschanel, Anna Kendrick, Gwen Stefani, James Corden, Walt Dohrn, Ron Funches, Caroline Hjelt, Aino Jawo & Kunal Nayyar","url":"https://itunes.apple.com/us/album/im-coming-out-mo-money-mo-problems/1154238159?i=1154239514","discNumber":1,"genreNames":["Soundtrack","Music","Children's Music","Pop"],"durationInMillis":61914,"releaseDate":"2016-09-23","name":"I'm Coming Out / Mo' Money Mo' Problems","isrc":"USRC11601596","albumName":"Trolls (Original Motion Picture Soundtrack)","playParams":{"id":"1154239514","kind":"song"},"trackNumber":7,"composerName":"N/A"}},{"id":"1154239481","type":"songs","href":"/v1/catalog/us/songs/1154239481","attributes":{"previews":[{"url":"https://audio-ssl.itunes.apple.com/apple-assets-us-std-000001/AudioPreview71/v4/88/6b/1e/886b1e51-0022-2757-2026-9bcef0580745/mzaf_2241623720019470072.plus.aac.p.m4a"}],"artwork":{"width":1500,"height":1500,"url":"https://is5-ssl.mzstatic.com/image/thumb/Music62/v4/b1/55/7a/b1557a58-fff7-89f0-3615-d53f2549f911/source/{w}x{h}bb.jpeg","bgColor":"42296e","textColor1":"ffffff","textColor2":"f4d631","textColor3":"d9d4e1","textColor4":"d1b33d"},"artistName":"Anna Kendrick, Gwen Stefani, James Corden, Ron Funches, Walt Dohrn, Caroline Hjelt, Aino Jawo & Kunal Nayyar","url":"https://itunes.apple.com/us/album/move-your-feet-d-a-n-c-e-its-a-sunshine-day/1154238159?i=1154239481","discNumber":1,"genreNames":["Soundtrack","Music","Children's Music","Pop"],"durationInMillis":156500,"releaseDate":"2016-09-23","name":"Move Your Feet / D.A.N.C.E. / It's a Sunshine Day","isrc":"USRC11601592","albumName":"Trolls (Original Motion Picture Soundtrack)","playParams":{"id":"1154239481","kind":"song"},"trackNumber":3,"composerName":"N/A"}}]}}}
//"""
//
//let jsonData = jsonString.data(using: .utf8)!
//let decoder = JSONDecoder()
//
//let results = try! decoder.decode(Results.self, from: jsonData)
//print(results.tracks)
