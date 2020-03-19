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
    
    self.communicator = [[Communicator alloc] init];
    self.communicator.delegate = self;
    [self.communicator fetchMovieList:FetchPopular];
    [self.communicator fetchMovieList:FetchNowPlaying];
    
    self.moviesTableView.delegate = self;
    self.moviesTableView.dataSource = self;
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
    NSLog(@"%@",movie.description);
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
        [cell.movieTitleLabel setText:movie.title];
        [cell.movieOverviewLabel setText:movie.overview];
        
        NSMutableAttributedString* rating = [[NSMutableAttributedString alloc] initWithString:movie.vote_average.stringValue];
        
        NSTextAttachment* rating_symbol = [NSTextAttachment textAttachmentWithImage:[UIImage systemImageNamed:@"star"]];
        NSAttributedString* rating_symbol_str = [NSAttributedString attributedStringWithAttachment:rating_symbol];
        [rating replaceCharactersInRange:NSMakeRange(0, 0) withAttributedString:rating_symbol_str];
        
        [cell.movieRatingLabel setAttributedText:rating];
        
        NSURLSessionDownloadTask* poster_download = [[NSURLSession sharedSession] downloadTaskWithURL:movie.poster_path completionHandler:^(NSURL * _Nullable location, NSURLResponse * _Nullable response, NSError * _Nullable error) {
            UIImage* poster = [UIImage imageWithData:[NSData dataWithContentsOfURL:location]];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [cell.movieImageView setImage:poster];
            });
        }];
        
        [poster_download resume];
    }
    
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
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

#pragma mark - Table View Section Headers
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

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 22;
}

@end
