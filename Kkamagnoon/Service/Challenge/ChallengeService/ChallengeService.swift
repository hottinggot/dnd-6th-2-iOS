//
//  ChallengeService.swift
//  Kkamagnoon
//
//  Created by 서정 on 2022/02/21.
//

import RxSwift
import RxAlamofire
import Alamofire

class ChallengeService: Service {
    func getChallenge() -> Observable<GetChallengeMain> {
        let endpoint = ChallengeEndPointCases.getChallenge
        let request = makeRequest(endpoint: endpoint)

        return RxAlamofire.request(request as URLRequestConvertible)
            .responseData()
            .asObservable()
            .map { _, resData -> GetChallengeMain  in
//                print(http)

                let decoder = JSONDecoder()

                do {
                    let result = try decoder.decode(GetChallengeMain.self, from: resData)
//                    print("RES>>>>>\(result)")
                    return result
                } catch {
                    print(error)
                }

                return GetChallengeMain()
            }
    }

    func getChallengeArticle() -> Observable<Tip> {
        let endpoint = ChallengeEndPointCases.getChallenge
        let request = makeRequest(endpoint: endpoint)

        return RxAlamofire.request(request as URLRequestConvertible)
            .responseData()
            .asObservable()
            .map { _, resData -> Tip  in
//                print(http)

                let decoder = JSONDecoder()

                do {
                    let result = try decoder.decode(Tip.self, from: resData)
//                    print("RES>>>>>\(result)")
                    return result
                } catch {
                    print(error)
                }

                return Tip()
            }
    }

    func postChallengeArticle(article: CreateArticleDTO) {

    }

    func postChallengeArticleTemp(article: CreateArticleDTO) {

    }

    // 개발용
    func getChallengeKeyword() {

    }

    func postChallengeKeyword(content: String) {

    }

}
