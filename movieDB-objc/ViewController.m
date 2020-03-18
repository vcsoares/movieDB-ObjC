//
//  ViewController.m
//  movieDB-objc
//
//  Created by Vinícius Chagas on 16/03/20.
//  Copyright © 2020 Vinícius Chagas. All rights reserved.
//

#import "ViewController.h"
#import "Communicator.h"
#import "CommunicatorDelegate.h"
#import "Parser.h"

@interface ViewController () <CommunicatorDelegate>

@property Communicator* communicator;
@property NSArray* popularMovieList;
@property NSArray* nowPlayingMovieList;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.communicator = [[Communicator alloc] init];
    self.communicator.delegate = self;
    [self.communicator fetchMovieList:FetchPopular];
    [self.communicator fetchMovieList:FetchNowPlaying];
}


- (void)fetchMovieListFailedWithError:(nonnull NSError *)error {
    NSLog(@"-XXX- FETCH FAILED");
    NSLog(@"%@", error.localizedDescription);
}

- (void)receivedMovieList:(nonnull NSData *)json from:(FetchOption) option {
    NSLog(@"%@", json.description);
    
    NSError* error = nil;
    NSArray* movies = [Parser movieListFromJSON:json error:&error];
    
    if (error) {
        NSLog(@"-XXX- PARSE ERROR");
        NSLog(@"%@", error.localizedDescription);
        return;
    }
    
    switch (option) {
        case FetchPopular:
            NSLog(@"-VVV- FETCH POPULAR SUCCESS");
            self.popularMovieList = movies;
            break;
            
        default:
            NSLog(@"-VVV- FETCH NOW PLAYING SUCCESS");
            self.nowPlayingMovieList = movies;
            break;
    }
}

@end
