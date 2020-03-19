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
#import "Movie.h"
#import "MovieTableViewCell.h"

@interface ViewController () <CommunicatorDelegate, UITableViewDelegate, UITableViewDataSource>

@property Communicator* communicator;
@property NSArray* popularMovieList;
@property NSArray* nowPlayingMovieList;

@property (weak, nonatomic) IBOutlet UITableView *moviesTableView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.moviesTableView.delegate = self;
    self.moviesTableView.dataSource = self;
    
    self.communicator = [[Communicator alloc] init];
    self.communicator.delegate = self;
    [self.communicator fetchMovieList:FetchPopular];
    [self.communicator fetchMovieList:FetchNowPlaying];
}


- (void)fetchFailedWithError:(nonnull NSError *)error {
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
            Movie* movie = self.nowPlayingMovieList[0];
            [self.communicator fetchMovieDetails:movie];
            break;
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.moviesTableView reloadData];
    });
}

- (void)receivedMovieDetails:(nonnull NSData *)json for:(nonnull Movie *)movie {
    NSError* error = nil;
    [Parser detailsForMovie:movie from:json error:&error];
    NSLog(@"%@",movie.description);
}

#pragma mark - Table View Data Source -
- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    MovieTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"MovieCell"];
    
    if (cell == nil) {
        return [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"default"];
    }
     
    Movie* movie;
    
    switch (indexPath.section) {
        case 0:
            movie = self.popularMovieList[indexPath.row];
            break;
            
        default:
            movie = self.nowPlayingMovieList[indexPath.row];
            break;
    }
    
    [cell.movieTitleLabel setText:movie.title];
    [cell.movieOverviewLabel setText:movie.overview];
    [cell.movieRatingLabel setText:movie.vote_average.stringValue];
    
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (section) {
        case 0:
            NSLog(@"-!!!- SECTION: POPULAR --- COUNT: %d", (int)self.popularMovieList.count);
            return self.popularMovieList.count;
            break;
            
        default:
            NSLog(@"-!!!- SECTION: NOW PLAYING --- COUNT: %d", (int)self.nowPlayingMovieList.count);
            return self.nowPlayingMovieList.count;
            break;
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    switch (section) {
        case 0:
            NSLog(@"-!!!- SECTION: POPULAR");
            return @"Popular movies";
            break;
            
        default:
            NSLog(@"-!!!- SECTION: NOW PLAYING");
            return @"Now playing";
            break;
    }
}

@end
