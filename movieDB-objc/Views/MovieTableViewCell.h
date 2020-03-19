//
//  MovieTableViewCell.h
//  movieDB-objc
//
//  Created by Vinícius Chagas on 19/03/20.
//  Copyright © 2020 Vinícius Chagas. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MovieTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *movieImageView;
@property (weak, nonatomic) IBOutlet UILabel *movieTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *movieOverviewLabel;
@property (weak, nonatomic) IBOutlet UILabel *movieRatingLabel;

@end

NS_ASSUME_NONNULL_END
