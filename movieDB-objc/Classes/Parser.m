//
//  Parser.m
//  movieDB-objc
//
//  Created by Vinícius Chagas on 17/03/20.
//  Copyright © 2020 Vinícius Chagas. All rights reserved.
//

#import "Parser.h"
#import "Movie.h"

#define BASE_IMG_URL @"https://image.tmdb.org/t/p/w500"

@implementation Parser

+(NSArray*)movieListFromJSON:(NSData*) json error:(NSError**) error {
    NSError *error_buffer = nil;
    NSDictionary *parsed_object = [NSJSONSerialization JSONObjectWithData:json options:0 error:&error_buffer];
    
    if (error_buffer != nil) {
        *error = error_buffer;
        return nil;
    }
    
    NSMutableArray *movies = [[NSMutableArray alloc] init];
    
    NSArray *results = [parsed_object valueForKey:@"results"];
    NSLog(@"Count %d", (int)results.count);
    
    for (NSDictionary *movie_dict in results) {
        Movie *movie = [[Movie alloc] init];
        
        for (NSString *key in movie_dict) {
            if ([movie respondsToSelector:NSSelectorFromString(key)]) {
                if ([key isEqualToString:@"poster_path"]) {
                    NSString* pictureURL = [BASE_IMG_URL stringByAppendingString:[movie_dict valueForKey:key]];
                    NSLog(@"--!-- PICTURE URL: %@", pictureURL);
                    [movie setValue:pictureURL forKey:key];
                } else {
                    [movie setValue:[movie_dict valueForKey:key] forKey:key];
                }
            }
        }
        
        [movies addObject:movie];
    }
    
    return movies;
}

@end
