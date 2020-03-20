//
//  DetailsViewController.m
//  movieDB-objc
//
//  Created by Vinícius Chagas on 20/03/20.
//  Copyright © 2020 Vinícius Chagas. All rights reserved.
//

#import "DetailsViewController.h"
#import "Movie.h"

@interface DetailsViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *posterImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *genresLabel;
@property (weak, nonatomic) IBOutlet UILabel *ratingLabel;
@property (weak, nonatomic) IBOutlet UILabel *overviewLabel;

@end

@implementation DetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self.posterImageView.layer setCornerRadius:10];
}

- (void)setMovie:(Movie *)movie {
    [self.titleLabel setText:movie.title];
    [self.genresLabel setText:movie.genres];
    [self.overviewLabel setText:movie.overview];
    
    NSMutableAttributedString* rating = [[NSMutableAttributedString alloc] initWithString:movie.vote_average.stringValue];
    
    NSTextAttachment* rating_symbol = [NSTextAttachment textAttachmentWithImage:[UIImage systemImageNamed:@"star"]];
    NSAttributedString* rating_symbol_str = [NSAttributedString attributedStringWithAttachment:rating_symbol];
    [rating replaceCharactersInRange:NSMakeRange(0, 0) withAttributedString:rating_symbol_str];
    
    [self.ratingLabel setAttributedText:rating];
    
    NSURLSessionDownloadTask* poster_download = [[NSURLSession sharedSession] downloadTaskWithURL:movie.poster_path completionHandler:^(NSURL * _Nullable location, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        UIImage* poster = [UIImage imageWithData:[NSData dataWithContentsOfURL:location]];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.posterImageView setImage:poster];
        });
    }];
    
    [poster_download resume];
}

@end
