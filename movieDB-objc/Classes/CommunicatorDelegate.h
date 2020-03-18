//
//  CommunicatorDelegate.h
//  movieDB-objc
//
//  Created by Vinícius Chagas on 17/03/20.
//  Copyright © 2020 Vinícius Chagas. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol CommunicatorDelegate <NSObject>

-(void)receivedMovieList:(NSData*) json from:(FetchOption) option;
-(void)fetchMovieListFailedWithError:(NSError*) error;

@end

NS_ASSUME_NONNULL_END
