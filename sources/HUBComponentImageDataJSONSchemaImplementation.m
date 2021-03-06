/*
 *  Copyright (c) 2016 Spotify AB.
 *
 *  Licensed to the Apache Software Foundation (ASF) under one
 *  or more contributor license agreements.  See the NOTICE file
 *  distributed with this work for additional information
 *  regarding copyright ownership.  The ASF licenses this file
 *  to you under the Apache License, Version 2.0 (the
 *  "License"); you may not use this file except in compliance
 *  with the License.  You may obtain a copy of the License at
 *
 *  http://www.apache.org/licenses/LICENSE-2.0
 *
 *  Unless required by applicable law or agreed to in writing,
 *  software distributed under the License is distributed on an
 *  "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
 *  KIND, either express or implied.  See the License for the
 *  specific language governing permissions and limitations
 *  under the License.
 */

#import "HUBComponentImageDataJSONSchemaImplementation.h"

#import "HUBComponentImageDataImplementation.h"
#import "HUBMutableJSONPathImplementation.h"
#import "HUBJSONKeys.h"

@implementation HUBComponentImageDataJSONSchemaImplementation

@synthesize URLPath = _URLPath;
@synthesize placeholderIconIdentifierPath = _placeholderIconIdentifierPath;

- (instancetype)init
{
    return [self initWithURLPath:[[[HUBMutableJSONPathImplementation path] goTo:HUBJSONKeyURI] URLPath]
   placeholderIconIdentifierPath:[[[HUBMutableJSONPathImplementation path] goTo:HUBJSONKeyPlaceholder] stringPath]];
}

- (instancetype)initWithURLPath:(id<HUBJSONURLPath>)URLPath
  placeholderIconIdentifierPath:(id<HUBJSONStringPath>)placeholderIconIdentifierPath
{
    self = [super init];
    
    if (self) {
        _URLPath = URLPath;
        _placeholderIconIdentifierPath = placeholderIconIdentifierPath;
    }
    
    return self;
}

#pragma mark - HUBComponentImageDataJSONSchema

- (id)copy
{
    return [[HUBComponentImageDataJSONSchemaImplementation alloc] initWithURLPath:self.URLPath
                                                    placeholderIconIdentifierPath:self.placeholderIconIdentifierPath];
}

@end
