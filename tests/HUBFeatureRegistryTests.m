#import <XCTest/XCTest.h>

#import "HUBFeatureRegistryImplementation.h"
#import "HUBFeatureConfiguration.h"
#import "HUBFeatureRegistration.h"
#import "HUBContentProviderFactoryMock.h"
#import "HUBViewURIQualifierMock.h"

@interface HUBFeatureRegistryTests : XCTestCase

@property (nonatomic, strong) HUBFeatureRegistryImplementation *registry;

@end

@implementation HUBFeatureRegistryTests

#pragma mark - XCTestCase

- (void)setUp
{
    [super setUp];
    self.registry = [HUBFeatureRegistryImplementation new];
}

#pragma mark - Tests

- (void)testConfigurationPropertyAssignment
{
    NSURL * const rootViewURI = [NSURL URLWithString:@"spotify:hub:framework"];
    id<HUBContentProviderFactory> const contentProviderFactory = [HUBContentProviderFactoryMock new];
    
    id<HUBFeatureConfiguration> const configuration = [self.registry createFeatureConfigurationForRootViewURI:rootViewURI
                                                                                       contentProviderFactory:contentProviderFactory];
    
    XCTAssertEqualObjects(configuration.rootViewURI, rootViewURI);
    XCTAssertEqual(configuration.contentProviderFactory, contentProviderFactory);
}

- (void)testConflictingRootViewURIsTriggerAssert
{
    NSURL * const rootViewURI = [NSURL URLWithString:@"spotify:hub:framework"];
    id<HUBContentProviderFactory> const contentProviderFactory = [HUBContentProviderFactoryMock new];
    
    id<HUBFeatureConfiguration> const configuration = [self.registry createFeatureConfigurationForRootViewURI:rootViewURI
                                                                                       contentProviderFactory:contentProviderFactory];
    
    [self.registry registerFeatureWithConfiguration:configuration];
    XCTAssertThrows([self.registry registerFeatureWithConfiguration:configuration]);
}

- (void)testRegistrationAndConfigurationMatch
{
    NSURL * const rootViewURI = [NSURL URLWithString:@"spotify:hub:framework"];
    id<HUBContentProviderFactory> const contentProviderFactory = [HUBContentProviderFactoryMock new];
    
    id<HUBFeatureConfiguration> const configuration = [self.registry createFeatureConfigurationForRootViewURI:rootViewURI
                                                                                       contentProviderFactory:contentProviderFactory];
    
    configuration.customJSONSchemaIdentifier = @"custom schema";
    configuration.viewURIQualifier = [[HUBViewURIQualifierMock alloc] initWithDisqualifiedViewURIs:@[]];
    [self.registry registerFeatureWithConfiguration:configuration];
    
    HUBFeatureRegistration * const registration = [self.registry featureRegistrationForViewURI:rootViewURI];
    XCTAssertEqualObjects(registration.rootViewURI, configuration.rootViewURI);
    XCTAssertEqual(registration.contentProviderFactory, configuration.contentProviderFactory);
    XCTAssertEqualObjects(registration.customJSONSchemaIdentifier, configuration.customJSONSchemaIdentifier);
    XCTAssertEqual(registration.viewURIQualifier, configuration.viewURIQualifier);
}

- (void)testSubviewMatch
{
    NSURL * const rootViewURI = [NSURL URLWithString:@"spotify:hub:framework"];
    id<HUBContentProviderFactory> const contentProviderFactory = [HUBContentProviderFactoryMock new];
    
    id<HUBFeatureConfiguration> const configuration = [self.registry createFeatureConfigurationForRootViewURI:rootViewURI
                                                                                       contentProviderFactory:contentProviderFactory];
    
    [self.registry registerFeatureWithConfiguration:configuration];
    
    NSURL * const subviewURI = [NSURL URLWithString:[NSString stringWithFormat:@"%@:subview", rootViewURI.absoluteString]];
    XCTAssertEqualObjects([self.registry featureRegistrationForViewURI:subviewURI].rootViewURI, rootViewURI);
}

- (void)testDisqualifyingRootViewURI
{
    NSURL * const rootViewURI = [NSURL URLWithString:@"spotify:hub:framework"];
    id<HUBContentProviderFactory> const contentProviderFactory = [HUBContentProviderFactoryMock new];
    
    id<HUBFeatureConfiguration> const configuration = [self.registry createFeatureConfigurationForRootViewURI:rootViewURI
                                                                                       contentProviderFactory:contentProviderFactory];
    
    configuration.viewURIQualifier = [[HUBViewURIQualifierMock alloc] initWithDisqualifiedViewURIs:@[rootViewURI]];
    [self.registry registerFeatureWithConfiguration:configuration];
    
    XCTAssertNil([self.registry featureRegistrationForViewURI:rootViewURI]);
    
    NSURL * const subviewURI = [NSURL URLWithString:[NSString stringWithFormat:@"%@:subview", rootViewURI.absoluteString]];
    XCTAssertEqualObjects([self.registry featureRegistrationForViewURI:subviewURI].rootViewURI, rootViewURI);
}

- (void)testDisqualifyingSubviewURI
{
    NSURL * const rootViewURI = [NSURL URLWithString:@"spotify:hub:framework"];
    NSURL * const subviewURI = [NSURL URLWithString:[NSString stringWithFormat:@"%@:subview", rootViewURI.absoluteString]];
    id<HUBContentProviderFactory> const contentProviderFactory = [HUBContentProviderFactoryMock new];
    
    id<HUBFeatureConfiguration> const configuration = [self.registry createFeatureConfigurationForRootViewURI:rootViewURI
                                                                                       contentProviderFactory:contentProviderFactory];
    
    configuration.viewURIQualifier = [[HUBViewURIQualifierMock alloc] initWithDisqualifiedViewURIs:@[subviewURI]];
    [self.registry registerFeatureWithConfiguration:configuration];
    
    XCTAssertEqualObjects([self.registry featureRegistrationForViewURI:rootViewURI].rootViewURI, configuration.rootViewURI);
    XCTAssertNil([self.registry featureRegistrationForViewURI:subviewURI]);
}

@end
