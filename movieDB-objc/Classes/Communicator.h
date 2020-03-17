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

@property (weak, nonatomic) id delegate;
-(void)fetchMovieList;

@end

NS_ASSUME_NONNULL_END
