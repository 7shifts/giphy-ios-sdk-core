//
//  GPHClient.swift
//  GiphyCoreSDK
//
//  Created by Cem Kozinoglu on 4/24/17.
//  Copyright © 2017 Giphy. All rights reserved.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to
//  deal in the Software without restriction, including without limitation the
//  rights to use, copy, modify, merge, publish, distribute, sublicense, and/or
//  sell copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
//  FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS
//  IN THE SOFTWARE.
//

import Foundation

/// A JSON object.
public typealias GPHJSONObject = [String: Any]

//MARK: Generic Request & Completion Handlers

/// JSON/Error signature of generic request method
///
/// - parameter data: The JSON response (in case of success) or `nil` (in case of error).
/// - parameter response: The URLResponse object
/// - parameter error: The encountered error (in case of error) or `nil` (in case of success).
///
public typealias GPHCompletionHandler = (_ data: GPHJSONObject?, _ response: URLResponse?, _ error: Error?) -> Void

/// Single Result/Error signature of generic request method
///
/// - parameter result: The GPHResult response (in case of success) or `nil` (in case of error).
/// - parameter error: The encountered error (in case of error) or `nil` (in case of success).
///
public typealias GPHResultCompletionHandler = (_ result: GPHObject?, _ error: Error?) -> Void

/// Multiple Results/Error signature of generic request method
///
/// - parameter results: The GPHListResult response (in case of success) or `nil` (in case of error).
/// - parameter pagination: The GPHPagination object to represent totalcount/count/offset
/// - parameter error: The encountered error (in case of error) or `nil` (in case of success).
///
public typealias GPHListResultsCompletionHandler = (_ results: [GPHObject]?, _ pagination: GPHPagination?, _ error: Error?) -> Void

/// Multiple Results/Error signature of category request method
///
/// - parameter results: The GPHListResult response (in case of success) or `nil` (in case of error).
/// - parameter pagination: The GPHPagination object to represent totalcount/count/offset
/// - parameter error: The encountered error (in case of error) or `nil` (in case of success).
///
public typealias GPHListCategoriesCompletionHandler = (_ results: [GPHCategory]?, _ pagination: GPHPagination?, _ error: Error?) -> Void

/// Multiple Results/Error signature of term suggestion request method
///
/// - parameter results: The GPHListResult response (in case of success) or `nil` (in case of error).
/// - parameter error: The encountered error (in case of error) or `nil` (in case of success).
///
public typealias GPHListTermSuggestionsCompletionHandler = (_ results: [GPHTermSuggestion]?, _ error: Error?) -> Void

/// Entry point into the Swift API.
///
@objc public class GPHClient : GPHAbstractClient {
    // MARK: Properties
    
    /// Giphy API key.
    @objc public var apiKey: String {
        get { return _apiKey! }
        set { _apiKey = newValue }
    }
    
    
    //MARK: Search Endpoint
    
    /// Perform a search.
    ///
    /// - parameter query: Search parameters.
    /// - parameter media: Media type / optional (default: .gif)
    /// - parameter offset: offset of results (default: 0)
    /// - parameter limit: total hits you request (default: 25)
    /// - parameter rating: rating of the content / optional (default R)
    /// - parameter lang: language of the content / optional (default English)
    /// - parameter completionHandler: Completion handler to be notified of the request's outcome.
    /// - returns: A cancellable operation.
    ///
    @objc
    @discardableResult public func search(_ query: String,
                                   media: GPHMediaType = .gif,
                                   offset: Int = 0,
                                   limit: Int = 25,
                                   rating: GPHRatingType = .ratedR,
                                   lang: GPHLanguageType = .english,
                                   completionHandler: @escaping GPHListResultsCompletionHandler) -> Operation {
    
        
        let request = GPHRequestRouter.search(query, media, offset, limit, rating, lang).asURLRequest(apiKey)

        return self.listRequest(with: request, type: .search, media: media, completionHandler: completionHandler)
    }
    
    
    //MARK: Trending Endpoint
    
    /// Trending
    ///
    /// - parameter media: Media type / optional (default: .gif)
    /// - parameter offset: offset of results (default: 0)
    /// - parameter limit: total hits you request (default: 25)
    /// - parameter rating: rating of the content / optional (default R)
    /// - parameter completionHandler: Completion handler to be notified of the request's outcome.
    /// - returns: A cancellable operation.
    ///
    @objc
    @discardableResult public func trending(_  media: GPHMediaType = .gif,
                                     offset: Int = 0,
                                     limit: Int = 25,
                                     rating: GPHRatingType = .ratedR,
                                     completionHandler: @escaping GPHListResultsCompletionHandler) -> Operation {
    
        let request = GPHRequestRouter.trending(media, offset, limit, rating).asURLRequest(apiKey)
        
        return self.listRequest(with: request, type: .trending, media: media, completionHandler: completionHandler)
    }
    
    
    //MARK: Translate Endpoint
    
    /// Translate
    ///
    /// - parameter term: term or phrase to translate into a GIF|Sticker
    /// - parameter media: Media type / optional (default: .gif)
    /// - parameter rating: rating of the content / optional (default R)
    /// - parameter lang: language of the content / optional (default English)
    /// - parameter completionHandler: Completion handler to be notified of the request's outcome.
    /// - returns: A cancellable operation.
    ///
    @objc
    @discardableResult public func translate(_ term: String,
                                      media: GPHMediaType = .gif,
                                      rating: GPHRatingType = .ratedR,
                                      lang: GPHLanguageType = .english,
                                      completionHandler: @escaping GPHResultCompletionHandler) -> Operation {
    
        let request = GPHRequestRouter.translate(term, media, rating, lang).asURLRequest(apiKey)
        
        return self.getRequest(with: request, type: .translate, media: media, completionHandler: completionHandler)
    }
    
    
    //MARK: Random Endpoint
    
    /// Random
    ///
    /// Example: http://api.giphy.com/v1/gifs/random?api_key=dc6zaTOxFJmzC&tag=cats
    /// - parameter query: Search parameters.
    /// - parameter media: Media type / optional (default: .gif)
    /// - parameter rating: rating of the content / optional (default R)
    /// - parameter completionHandler: Completion handler to be notified of the request's outcome.
    /// - returns: A cancellable operation.
    ///
    @objc
    @discardableResult public func random(_ query: String,
                                   media: GPHMediaType = .gif,
                                   rating: GPHRatingType = .ratedR,
                                   completionHandler: @escaping GPHResultCompletionHandler) -> Operation {
    
        let request = GPHRequestRouter.random(query, media, rating).asURLRequest(apiKey)
        
        return self.getRequest(with: request, type: .random, media: media, completionHandler: completionHandler)
    }
    
    
    //MARK: Gifs by ID(s)
    
    /// GIF by ID
    ///
    /// - parameter id: Gif ID.
    /// - parameter completionHandler: Completion handler to be notified of the request's outcome.
    /// - returns: A cancellable operation.
    ///
    @objc
    @discardableResult public func gifByID(_ id: String,
                                    completionHandler: @escaping GPHResultCompletionHandler) -> Operation {
    
        let request = GPHRequestRouter.get(id).asURLRequest(apiKey)
        
        return self.getRequest(with: request, type: .get, media: .gif, completionHandler: completionHandler)
    }
    
    
    /// GIFs by IDs
    ///
    /// - parameter ids: Gif ID.
    /// - parameter completionHandler: Completion handler to be notified of the request's outcome.
    /// - returns: A cancellable operation.
    ///
    @objc
    @discardableResult public func gifsByIDs(_ ids: [String],
                                     completionHandler: @escaping GPHListResultsCompletionHandler) -> Operation {
    
        let request = GPHRequestRouter.getAll(ids).asURLRequest(apiKey)
        
        return self.listRequest(with: request, type: .getAll, media: .gif, completionHandler: completionHandler)
    }
    
    
    //MARK: Term Suggestion Endpoint
    
    /// Term Suggestions
    ///
    /// - parameter term: Word/Words
    /// - parameter completionHandler: Completion handler to be notified of the request's outcome.
    /// - returns: A cancellable operation.
    ///
    @objc
    @discardableResult public func termSuggestions(_ term: String,
                                             completionHandler: @escaping GPHListTermSuggestionsCompletionHandler) -> Operation {
        
        let request = GPHRequestRouter.termSuggestions(encodedStringForUrl(term)).asURLRequest(apiKey)
        
        return self.listTermSuggestionsRequest(with: request, type: .termSuggestions, media: .gif, completionHandler: completionHandler)
    }
    
    //MARK: Categories Endpoint
    
    /// Trending Categories
    ///
    /// - parameter root: GPHCategory object -- if nil all the top Categories(with gif) & sub-categories fetched(wihtout gif),
    ///                   if GPHCategory passed, its sub-categories with GIF information fetched
    /// - parameter media: Media type / optional (default: .gif)
    /// - parameter offset: offset of results (default: 0)
    /// - parameter limit: total hits you request (default: 25)
    /// - parameter rating: rating of the content / optional (default R)
    /// - parameter completionHandler: Completion handler to be notified of the request's outcome.
    /// - returns: A cancellable operation.
    ///
    @objc
    @discardableResult public func trendingCategories(_ root: GPHCategory? = nil,
                                                        media: GPHMediaType = .gif,
                                                        offset: Int = 0,
                                                        limit: Int = 25,
                                                        sort: String = "giphy",
                                                        completionHandler: @escaping GPHListCategoriesCompletionHandler) -> Operation {
        
        if let root = root {
            let request = GPHRequestRouter.subCategories(root.encodedPath, media, offset, limit, sort).asURLRequest(apiKey)
            
            return self.listCategoriesRequest(root, with: request, type: .subCategories, media: .gif, completionHandler: completionHandler)
        }
        
        let request = GPHRequestRouter.categories(media, offset, limit, sort).asURLRequest(apiKey)
        
        return self.listCategoriesRequest(with: request, type: .categories, media: .gif, completionHandler: completionHandler)

    }
    
    
    /// Category Content (only works with Sub-categories / top categories won't return content)
    ///
    /// - parameter root: GPHCategory object
    /// - parameter media: Media type / optional (default: .gif)
    /// - parameter offset: offset of results (default: 0)
    /// - parameter limit: total hits you request (default: 25)
    /// - parameter rating: rating of the content / optional (default R)
    /// - parameter lang: language of the content / optional (default English)
    /// - parameter completionHandler: Completion handler to be notified of the request's outcome.
    /// - returns: A cancellable operation.
    ///
    @objc
    @discardableResult public func categoryContent(_ root: GPHCategory,
                                                      media: GPHMediaType = .gif,
                                                      offset: Int = 0,
                                                      limit: Int = 25,
                                                      rating: GPHRatingType = .ratedR,
                                                      lang: GPHLanguageType = .english,
                                                      completionHandler: @escaping GPHListResultsCompletionHandler) -> Operation {
        
        let request = GPHRequestRouter.categoryContent(root.encodedPath, media, offset, limit, rating, lang).asURLRequest(apiKey)
        
        return self.listRequest(with: request, type: .categoryContent, media: .gif, completionHandler: completionHandler)
    }
    
}
