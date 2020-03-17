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

@implementation Communicator

-(void)fetchMovieList {
    NSString *urlAsString = [NSString stringWithFormat:@"https://api.themoviedb.org/3/movie/now_playing?api_key=%@", API_KEY];
    NSURL *url = [[NSURL alloc] initWithString:urlAsString];
    NSLog(@"%@", urlAsString);
    
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request
                                            completionHandler:
        ^(NSData *data, NSURLResponse *response, NSError *error) {
            if (error) {
                NSLog(@"--X-- FETCH ERROR");
                [self.delegate fetchMovieListFailedWithError:error];
            } else {
                NSLog(@"--V-- FETCH SUCCESS");
                [self.delegate receivedMovieList:data];
            }
        }];

    [task resume];
}
@end
