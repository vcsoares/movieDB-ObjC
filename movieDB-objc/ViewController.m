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
#import "DetailsViewController.h"

@interface ViewController () <CommunicatorDelegate, UITableViewDelegate, UITableViewDataSource>

@property Communicator* communicator;
@property NSArray* popularMovieList;
@property NSArray* nowPlayingMovieList;

@property (weak, nonatomic) IBOutlet UITableView *moviesTableView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.communicator = [[Communicator alloc] init];
    self.communicator.delegate = self;
    [self.communicator fetchMovieList:FetchPopular];
    [self.communicator fetchMovieList:FetchNowPlaying];
    
    self.moviesTableView.delegate = self;
    self.moviesTableView.dataSource = self;
    
    UISearchController* searchController = [[UISearchController alloc] init];
    self.navigationItem.searchController = searchController;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    DetailsViewController* detailsVC = [segue destinationViewController];
    
    if (detailsVC != nil && [sender isKindOfClass:[Movie class]]) {
        [detailsVC loadViewIfNeeded];
        [detailsVC setMovie:sender];
    }
}

#pragma mark - Communicator Delegate
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
            break;
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.moviesTableView reloadData];
    });
}

- (void)receivedMovieDetails:(nonnull NSData *)json for:(nonnull Movie *)movie {
    NSError* error = nil;
    
    [Parser detailsForMovie:movie from:json error:&error];
    
    if (error != nil) {
        NSLog(@"-XXX- FETCH DETAILS ERROR");
        NSLog(@"%@", error.localizedDescription);
        return;
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self performSegueWithIdentifier:@"ShowMovie" sender:movie];
    });
}

#pragma mark - Table View Data Source
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
    
    if (movie != nil) {
        [cell populateCellWithMovie:movie];
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 148;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (section) {
        case 0:
            NSLog(@"-!!!- SECTION: POPULAR --- COUNT: %d", (int)self.popularMovieList.count);
            return 2;
            break;
            
        default:
            NSLog(@"-!!!- SECTION: NOW PLAYING --- COUNT: %d", (int)self.nowPlayingMovieList.count);
            return self.nowPlayingMovieList.count;
            break;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    Movie* movie;
    
    switch (indexPath.section) {
        case 0:
            movie = self.popularMovieList[indexPath.row];
            break;
            
        default:
            movie = self.nowPlayingMovieList[indexPath.row];
            break;
    }
    
    if (movie != nil) {
        [self.communicator fetchMovieDetails:movie];
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - Table View Section Headers
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 22;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView* header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 22)];
    UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, tableView.frame.size.width, 22)];
    
    [label setFont:[UIFont systemFontOfSize:17 weight:UIFontWeightSemibold]];
    
    switch (section) {
        case 0:
            NSLog(@"-!!!- SECTION: POPULAR");
            [label setText:@"Popular movies"];
            break;
            
        default:
            NSLog(@"-!!!- SECTION: NOW PLAYING");
            [label setText:@"Now playing"];
            break;
    }
    
    [header addSubview:label];
    
    return header;
}

@end
