//
//  SearchViewController.h
//  movieDB-objc
//
//  Created by Vinícius Chagas on 26/03/20.
//  Copyright © 2020 Vinícius Chagas. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class Communicator;

@interface SearchViewController : UIViewController

@property Communicator* communicator;

@end

NS_ASSUME_NONNULL_END
