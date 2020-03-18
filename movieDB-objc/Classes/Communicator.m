//
//  Communicator.m
//  movieDB-objc
//
//  Created by Vinícius Chagas on 17/03/20.
//  Copyright © 2020 Vinícius Chagas. All rights reserved.
//

#import "Communicator.h"
#import "CommunicatorDelegate.h"

#define API_KEY @"f0fe433e69bcdce6b29dcd66e5661af9"
#define NOW_PLAYING_URL @"https://api.themoviedb.org/3/movie/now_playing?api_key=%@"
#define POPULAR_URL @"https://api.themoviedb.org/3/movie/popular?api_key=%@"
#define GENRE_URL @"https://api.themoviedb.org/3/genre/movie/list?api_key=%@"
#define DETAILS_URL @"https://api.themoviedb.org/3/movie/%@?api_key=%@"

@implementation Communicator

-(void)fetchMovieDetails:(Movie *)movie {
    NSString *url_string = [NSString stringWithFormat:DETAILS_URL, movie.id, API_KEY];
    NSURL *url = [[NSURL alloc] initWithString:url_string];
    NSLog(@"%@", url_string);
    
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request
                                            completionHandler:
        ^(NSData *data, NSURLResponse *response, NSError *error) {
            if (error) {
                NSLog(@"--X-- FETCH MOVIE ERROR");
                NSLog(@"%@", error.localizedDescription);
            } else {
                NSLog(@"--V-- FETCH MOVIE SUCCESS");
                [self.delegate receivedMovieDetails:data for:movie];
            }
        }];
    
    [task resume];
}

-(void)fetchMovieList:(FetchOption)option {
    NSString *url_string;
    
    switch (option) {
        case FetchPopular:
            url_string = [NSString stringWithFormat:POPULAR_URL, API_KEY];
            break;
            
        default:
            url_string = [NSString stringWithFormat:NOW_PLAYING_URL, API_KEY];
            break;
    }

    NSURL *url = [[NSURL alloc] initWithString:url_string];
    NSLog(@"%@", url_string);
    
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request
                                            completionHandler:
        ^(NSData *data, NSURLResponse *response, NSError *error) {
            if (error) {
                NSLog(@"--X-- FETCH ERROR");
                [self.delegate fetchFailedWithError:error];
            } else {
                NSLog(@"--V-- FETCH SUCCESS");
                [self.delegate receivedMovieList:data from:option];
            }
        }];

    [task resume];
}

@end
