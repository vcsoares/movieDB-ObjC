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

@interface ViewController () <CommunicatorDelegate>

@property Communicator* communicator;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.communicator = [[Communicator alloc] init];
    self.communicator.delegate = self;
    [self.communicator fetchMovieList];
}


- (void)fetchMovieListFailedWithError:(nonnull NSError *)error {
    NSLog(@"-XXX- FETCH FAILED");
    NSLog(error.localizedDescription);
}

- (void)receivedMovieList:(nonnull NSData *)json {
    NSLog(@"-VVV- FETCH SUCCESS");
    NSLog(json.description);
}

@end
