//
//  Communicator.h
//  movieDB-objc
//
//  Created by Vinícius Chagas on 17/03/20.
//  Copyright © 2020 Vinícius Chagas. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol CommunicatorDelegate;

@interface Communicator : NSObject

typedef NS_ENUM(NSInteger, FetchOption) {
    FetchNowPlaying,
    FetchPopular,
};

@property (weak, nonatomic) id delegate;
-(void)fetchMovieList:(FetchOption)option;

@end

NS_ASSUME_NONNULL_END
