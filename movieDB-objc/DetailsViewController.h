//
//  DetailsViewController.h
//  movieDB-objc
//
//  Created by Vinícius Chagas on 20/03/20.
//  Copyright © 2020 Vinícius Chagas. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class Movie;
@interface DetailsViewController : UIViewController

@property (nonatomic) Movie* movie;

@end

NS_ASSUME_NONNULL_END
