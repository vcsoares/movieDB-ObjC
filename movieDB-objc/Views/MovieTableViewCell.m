//
//  MovieTableViewCell.m
//  movieDB-objc
//
//  Created by Vinícius Chagas on 19/03/20.
//  Copyright © 2020 Vinícius Chagas. All rights reserved.
//

#import "MovieTableViewCell.h"

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

@end
