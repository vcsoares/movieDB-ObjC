//
//  MovieTableViewCell.m
//  movieDB-objc
//
//  Created by Vinícius Chagas on 19/03/20.
//  Copyright © 2020 Vinícius Chagas. All rights reserved.
//

#import "MovieTableViewCell.h"
#import "Movie.h"

@implementation MovieTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self.movieImageView.layer setCornerRadius:10];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)populateCellWithMovie:(Movie *)movie {
    [self.movieTitleLabel setText:movie.title];
    [self.movieOverviewLabel setText:movie.overview];
    
    NSMutableAttributedString* rating = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%.1f",[movie.vote_average doubleValue]]];
    
    NSTextAttachment* rating_symbol = [NSTextAttachment textAttachmentWithImage:[UIImage systemImageNamed:@"star"]];
    NSAttributedString* rating_symbol_str = [NSAttributedString attributedStringWithAttachment:rating_symbol];
    [rating replaceCharactersInRange:NSMakeRange(0, 0) withAttributedString:rating_symbol_str];
    
    [self.movieRatingLabel setAttributedText:rating];
    
    NSURLSessionDownloadTask* poster_download = [[NSURLSession sharedSession] downloadTaskWithURL:movie.poster_path completionHandler:^(NSURL * _Nullable location, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        UIImage* poster = [UIImage imageWithData:[NSData dataWithContentsOfURL:location]];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.movieImageView setImage:poster];
        });
    }];
    
    [poster_download resume];
}

@end
