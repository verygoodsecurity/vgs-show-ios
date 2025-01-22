#import <Foundation/NSArray.h>
#import <Foundation/NSDictionary.h>
#import <Foundation/NSError.h>
#import <Foundation/NSObject.h>
#import <Foundation/NSSet.h>
#import <Foundation/NSString.h>
#import <Foundation/NSValue.h>

@class AnalyticsVGSAnalyticsEvent, AnalyticsDefaultEventParams, AnalyticsKotlinEnumCompanion, AnalyticsKotlinEnum<E>, AnalyticsVGSAnalyticsCopyFormat, AnalyticsKotlinArray<T>, AnalyticsVGSAnalyticsStatus, AnalyticsVGSAnalyticsEventAttachFile, AnalyticsVGSAnalyticsEventAutofill, AnalyticsVGSAnalyticsEventCname, AnalyticsVGSAnalyticsEventContentRendering, AnalyticsVGSAnalyticsEventContentSharing, AnalyticsVGSAnalyticsEventCopyToClipboard, AnalyticsVGSAnalyticsEventFieldAttach, AnalyticsVGSAnalyticsEventFieldDetach, AnalyticsVGSAnalyticsUpstream, AnalyticsVGSAnalyticsEventRequest, AnalyticsVGSAnalyticsEventRequestBuilder, AnalyticsVGSAnalyticsMappingPolicy, AnalyticsVGSAnalyticsEventResponse, AnalyticsVGSAnalyticsEventScan, AnalyticsVGSAnalyticsEventSecureTextRange, AnalyticsVGSAnalyticsUpstreamCompanion;

@protocol AnalyticsKotlinComparable, AnalyticsKotlinIterator;

NS_ASSUME_NONNULL_BEGIN
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wunknown-warning-option"
#pragma clang diagnostic ignored "-Wincompatible-property-type"
#pragma clang diagnostic ignored "-Wnullability"

#pragma push_macro("_Nullable_result")
#if !__has_feature(nullability_nullable_result)
#undef _Nullable_result
#define _Nullable_result _Nullable
#endif

__attribute__((swift_name("KotlinBase")))
@interface AnalyticsBase : NSObject
- (instancetype)init __attribute__((unavailable));
+ (instancetype)new __attribute__((unavailable));
+ (void)initialize __attribute__((objc_requires_super));
@end

@interface AnalyticsBase (AnalyticsBaseCopying) <NSCopying>
@end

__attribute__((swift_name("KotlinMutableSet")))
@interface AnalyticsMutableSet<ObjectType> : NSMutableSet<ObjectType>
@end

__attribute__((swift_name("KotlinMutableDictionary")))
@interface AnalyticsMutableDictionary<KeyType, ObjectType> : NSMutableDictionary<KeyType, ObjectType>
@end

@interface NSError (NSErrorAnalyticsKotlinException)
@property (readonly) id _Nullable kotlinException;
@end

__attribute__((swift_name("KotlinNumber")))
@interface AnalyticsNumber : NSNumber
- (instancetype)initWithChar:(char)value __attribute__((unavailable));
- (instancetype)initWithUnsignedChar:(unsigned char)value __attribute__((unavailable));
- (instancetype)initWithShort:(short)value __attribute__((unavailable));
- (instancetype)initWithUnsignedShort:(unsigned short)value __attribute__((unavailable));
- (instancetype)initWithInt:(int)value __attribute__((unavailable));
- (instancetype)initWithUnsignedInt:(unsigned int)value __attribute__((unavailable));
- (instancetype)initWithLong:(long)value __attribute__((unavailable));
- (instancetype)initWithUnsignedLong:(unsigned long)value __attribute__((unavailable));
- (instancetype)initWithLongLong:(long long)value __attribute__((unavailable));
- (instancetype)initWithUnsignedLongLong:(unsigned long long)value __attribute__((unavailable));
- (instancetype)initWithFloat:(float)value __attribute__((unavailable));
- (instancetype)initWithDouble:(double)value __attribute__((unavailable));
- (instancetype)initWithBool:(BOOL)value __attribute__((unavailable));
- (instancetype)initWithInteger:(NSInteger)value __attribute__((unavailable));
- (instancetype)initWithUnsignedInteger:(NSUInteger)value __attribute__((unavailable));
+ (instancetype)numberWithChar:(char)value __attribute__((unavailable));
+ (instancetype)numberWithUnsignedChar:(unsigned char)value __attribute__((unavailable));
+ (instancetype)numberWithShort:(short)value __attribute__((unavailable));
+ (instancetype)numberWithUnsignedShort:(unsigned short)value __attribute__((unavailable));
+ (instancetype)numberWithInt:(int)value __attribute__((unavailable));
+ (instancetype)numberWithUnsignedInt:(unsigned int)value __attribute__((unavailable));
+ (instancetype)numberWithLong:(long)value __attribute__((unavailable));
+ (instancetype)numberWithUnsignedLong:(unsigned long)value __attribute__((unavailable));
+ (instancetype)numberWithLongLong:(long long)value __attribute__((unavailable));
+ (instancetype)numberWithUnsignedLongLong:(unsigned long long)value __attribute__((unavailable));
+ (instancetype)numberWithFloat:(float)value __attribute__((unavailable));
+ (instancetype)numberWithDouble:(double)value __attribute__((unavailable));
+ (instancetype)numberWithBool:(BOOL)value __attribute__((unavailable));
+ (instancetype)numberWithInteger:(NSInteger)value __attribute__((unavailable));
+ (instancetype)numberWithUnsignedInteger:(NSUInteger)value __attribute__((unavailable));
@end

__attribute__((swift_name("KotlinByte")))
@interface AnalyticsByte : AnalyticsNumber
- (instancetype)initWithChar:(char)value;
+ (instancetype)numberWithChar:(char)value;
@end

__attribute__((swift_name("KotlinUByte")))
@interface AnalyticsUByte : AnalyticsNumber
- (instancetype)initWithUnsignedChar:(unsigned char)value;
+ (instancetype)numberWithUnsignedChar:(unsigned char)value;
@end

__attribute__((swift_name("KotlinShort")))
@interface AnalyticsShort : AnalyticsNumber
- (instancetype)initWithShort:(short)value;
+ (instancetype)numberWithShort:(short)value;
@end

__attribute__((swift_name("KotlinUShort")))
@interface AnalyticsUShort : AnalyticsNumber
- (instancetype)initWithUnsignedShort:(unsigned short)value;
+ (instancetype)numberWithUnsignedShort:(unsigned short)value;
@end

__attribute__((swift_name("KotlinInt")))
@interface AnalyticsInt : AnalyticsNumber
- (instancetype)initWithInt:(int)value;
+ (instancetype)numberWithInt:(int)value;
@end

__attribute__((swift_name("KotlinUInt")))
@interface AnalyticsUInt : AnalyticsNumber
- (instancetype)initWithUnsignedInt:(unsigned int)value;
+ (instancetype)numberWithUnsignedInt:(unsigned int)value;
@end

__attribute__((swift_name("KotlinLong")))
@interface AnalyticsLong : AnalyticsNumber
- (instancetype)initWithLongLong:(long long)value;
+ (instancetype)numberWithLongLong:(long long)value;
@end

__attribute__((swift_name("KotlinULong")))
@interface AnalyticsULong : AnalyticsNumber
- (instancetype)initWithUnsignedLongLong:(unsigned long long)value;
+ (instancetype)numberWithUnsignedLongLong:(unsigned long long)value;
@end

__attribute__((swift_name("KotlinFloat")))
@interface AnalyticsFloat : AnalyticsNumber
- (instancetype)initWithFloat:(float)value;
+ (instancetype)numberWithFloat:(float)value;
@end

__attribute__((swift_name("KotlinDouble")))
@interface AnalyticsDouble : AnalyticsNumber
- (instancetype)initWithDouble:(double)value;
+ (instancetype)numberWithDouble:(double)value;
@end

__attribute__((swift_name("KotlinBoolean")))
@interface AnalyticsBoolean : AnalyticsNumber
- (instancetype)initWithBool:(BOOL)value;
+ (instancetype)numberWithBool:(BOOL)value;
@end

__attribute__((objc_subclassing_restricted))
__attribute__((swift_name("VGSSharedAnalyticsManager")))
@interface AnalyticsVGSSharedAnalyticsManager : AnalyticsBase
- (instancetype)initWithSource:(NSString *)source sourceVersion:(NSString *)sourceVersion dependencyManager:(NSString *)dependencyManager __attribute__((swift_name("init(source:sourceVersion:dependencyManager:)"))) __attribute__((objc_designated_initializer));
- (void)cancelAll __attribute__((swift_name("cancelAll()")));
- (void)captureVault:(NSString *)vault environment:(NSString *)environment formId:(NSString *)formId event:(AnalyticsVGSAnalyticsEvent *)event __attribute__((swift_name("capture(vault:environment:formId:event:)")));
- (BOOL)getIsEnabled __attribute__((swift_name("getIsEnabled()")));
- (void)setIsEnabledIsEnabled:(BOOL)isEnabled __attribute__((swift_name("setIsEnabled(isEnabled:)")));
@end

__attribute__((objc_subclassing_restricted))
__attribute__((swift_name("DefaultEventParams")))
@interface AnalyticsDefaultEventParams : AnalyticsBase
- (instancetype)initWithVault:(NSString *)vault environment:(NSString *)environment source:(NSString *)source sourceVersion:(NSString *)sourceVersion dependencyManager:(NSString *)dependencyManager __attribute__((swift_name("init(vault:environment:source:sourceVersion:dependencyManager:)"))) __attribute__((objc_designated_initializer));
- (AnalyticsDefaultEventParams *)doCopyVault:(NSString *)vault environment:(NSString *)environment source:(NSString *)source sourceVersion:(NSString *)sourceVersion dependencyManager:(NSString *)dependencyManager __attribute__((swift_name("doCopy(vault:environment:source:sourceVersion:dependencyManager:)")));
- (BOOL)isEqual:(id _Nullable)other __attribute__((swift_name("isEqual(_:)")));
- (NSDictionary<NSString *, id> *)getParams __attribute__((swift_name("getParams()")));
- (NSUInteger)hash __attribute__((swift_name("hash()")));
- (NSString *)description __attribute__((swift_name("description()")));
@end

__attribute__((swift_name("KotlinComparable")))
@protocol AnalyticsKotlinComparable
@required
- (int32_t)compareToOther:(id _Nullable)other __attribute__((swift_name("compareTo(other:)")));
@end

__attribute__((swift_name("KotlinEnum")))
@interface AnalyticsKotlinEnum<E> : AnalyticsBase <AnalyticsKotlinComparable>
- (instancetype)initWithName:(NSString *)name ordinal:(int32_t)ordinal __attribute__((swift_name("init(name:ordinal:)"))) __attribute__((objc_designated_initializer));
@property (class, readonly, getter=companion) AnalyticsKotlinEnumCompanion *companion __attribute__((swift_name("companion")));
- (int32_t)compareToOther:(E)other __attribute__((swift_name("compareTo(other:)")));
- (BOOL)isEqual:(id _Nullable)other __attribute__((swift_name("isEqual(_:)")));
- (NSUInteger)hash __attribute__((swift_name("hash()")));
- (NSString *)description __attribute__((swift_name("description()")));
@property (readonly) NSString *name __attribute__((swift_name("name")));
@property (readonly) int32_t ordinal __attribute__((swift_name("ordinal")));
@end

__attribute__((objc_subclassing_restricted))
__attribute__((swift_name("VGSAnalyticsCopyFormat")))
@interface AnalyticsVGSAnalyticsCopyFormat : AnalyticsKotlinEnum<AnalyticsVGSAnalyticsCopyFormat *>
+ (instancetype)alloc __attribute__((unavailable));
+ (instancetype)allocWithZone:(struct _NSZone *)zone __attribute__((unavailable));
- (instancetype)initWithName:(NSString *)name ordinal:(int32_t)ordinal __attribute__((swift_name("init(name:ordinal:)"))) __attribute__((objc_designated_initializer)) __attribute__((unavailable));
@property (class, readonly) AnalyticsVGSAnalyticsCopyFormat *raw __attribute__((swift_name("raw")));
@property (class, readonly) AnalyticsVGSAnalyticsCopyFormat *formatted __attribute__((swift_name("formatted")));
+ (AnalyticsKotlinArray<AnalyticsVGSAnalyticsCopyFormat *> *)values __attribute__((swift_name("values()")));
@property (class, readonly) NSArray<AnalyticsVGSAnalyticsCopyFormat *> *entries __attribute__((swift_name("entries")));
- (NSString *)getAnalyticsName __attribute__((swift_name("getAnalyticsName()")));
@end

__attribute__((swift_name("VGSAnalyticsEvent")))
@interface AnalyticsVGSAnalyticsEvent : AnalyticsBase

/**
 * @note annotations
 *   kotlin.jvm.JvmName(name="getEventParams")
*/
- (NSDictionary<NSString *, id> *)getParams __attribute__((swift_name("getParams()")));

/**
 * @note This property has protected visibility in Kotlin source and is intended only for use by subclasses.
*/
@property (readonly) AnalyticsMutableDictionary<NSString *, id> *params __attribute__((swift_name("params")));

/**
 * @note This property has protected visibility in Kotlin source and is intended only for use by subclasses.
*/
@property (readonly) NSString *type __attribute__((swift_name("type")));
@end

__attribute__((objc_subclassing_restricted))
__attribute__((swift_name("VGSAnalyticsEvent.AttachFile")))
@interface AnalyticsVGSAnalyticsEventAttachFile : AnalyticsVGSAnalyticsEvent
- (instancetype)initWithStatus:(AnalyticsVGSAnalyticsStatus *)status __attribute__((swift_name("init(status:)"))) __attribute__((objc_designated_initializer));
- (AnalyticsVGSAnalyticsEventAttachFile *)doCopyStatus:(AnalyticsVGSAnalyticsStatus *)status __attribute__((swift_name("doCopy(status:)")));
- (BOOL)isEqual:(id _Nullable)other __attribute__((swift_name("isEqual(_:)")));
- (NSUInteger)hash __attribute__((swift_name("hash()")));
- (NSString *)description __attribute__((swift_name("description()")));

/**
 * @note This property has protected visibility in Kotlin source and is intended only for use by subclasses.
*/
@property (readonly) AnalyticsMutableDictionary<NSString *, id> *params __attribute__((swift_name("params")));

/**
 * @note This property has protected visibility in Kotlin source and is intended only for use by subclasses.
*/
@property (readonly) NSString *type __attribute__((swift_name("type")));
@end

__attribute__((objc_subclassing_restricted))
__attribute__((swift_name("VGSAnalyticsEvent.Autofill")))
@interface AnalyticsVGSAnalyticsEventAutofill : AnalyticsVGSAnalyticsEvent
- (instancetype)initWithFieldType:(NSString *)fieldType __attribute__((swift_name("init(fieldType:)"))) __attribute__((objc_designated_initializer));
- (AnalyticsVGSAnalyticsEventAutofill *)doCopyFieldType:(NSString *)fieldType __attribute__((swift_name("doCopy(fieldType:)")));
- (BOOL)isEqual:(id _Nullable)other __attribute__((swift_name("isEqual(_:)")));
- (NSUInteger)hash __attribute__((swift_name("hash()")));
- (NSString *)description __attribute__((swift_name("description()")));

/**
 * @note This property has protected visibility in Kotlin source and is intended only for use by subclasses.
*/
@property (readonly) AnalyticsMutableDictionary<NSString *, id> *params __attribute__((swift_name("params")));

/**
 * @note This property has protected visibility in Kotlin source and is intended only for use by subclasses.
*/
@property (readonly) NSString *type __attribute__((swift_name("type")));
@end

__attribute__((objc_subclassing_restricted))
__attribute__((swift_name("VGSAnalyticsEvent.Cname")))
@interface AnalyticsVGSAnalyticsEventCname : AnalyticsVGSAnalyticsEvent
- (instancetype)initWithStatus:(AnalyticsVGSAnalyticsStatus *)status hostname:(NSString *)hostname latency:(AnalyticsLong * _Nullable)latency __attribute__((swift_name("init(status:hostname:latency:)"))) __attribute__((objc_designated_initializer));
- (AnalyticsVGSAnalyticsEventCname *)doCopyStatus:(AnalyticsVGSAnalyticsStatus *)status hostname:(NSString *)hostname latency:(AnalyticsLong * _Nullable)latency __attribute__((swift_name("doCopy(status:hostname:latency:)")));
- (BOOL)isEqual:(id _Nullable)other __attribute__((swift_name("isEqual(_:)")));
- (NSUInteger)hash __attribute__((swift_name("hash()")));
- (NSString *)description __attribute__((swift_name("description()")));

/**
 * @note This property has protected visibility in Kotlin source and is intended only for use by subclasses.
*/
@property (readonly) AnalyticsMutableDictionary<NSString *, id> *params __attribute__((swift_name("params")));

/**
 * @note This property has protected visibility in Kotlin source and is intended only for use by subclasses.
*/
@property (readonly) NSString *type __attribute__((swift_name("type")));
@end

__attribute__((objc_subclassing_restricted))
__attribute__((swift_name("VGSAnalyticsEvent.ContentRendering")))
@interface AnalyticsVGSAnalyticsEventContentRendering : AnalyticsVGSAnalyticsEvent
- (instancetype)initWithStatus:(AnalyticsVGSAnalyticsStatus *)status fieldType:(NSString *)fieldType contentPath:(NSString *)contentPath __attribute__((swift_name("init(status:fieldType:contentPath:)"))) __attribute__((objc_designated_initializer));
- (AnalyticsVGSAnalyticsEventContentRendering *)doCopyStatus:(AnalyticsVGSAnalyticsStatus *)status fieldType:(NSString *)fieldType contentPath:(NSString *)contentPath __attribute__((swift_name("doCopy(status:fieldType:contentPath:)")));
- (BOOL)isEqual:(id _Nullable)other __attribute__((swift_name("isEqual(_:)")));
- (NSUInteger)hash __attribute__((swift_name("hash()")));
- (NSString *)description __attribute__((swift_name("description()")));
@property (readonly) NSString *contentPath __attribute__((swift_name("contentPath")));
@property (readonly) NSString *fieldType __attribute__((swift_name("fieldType")));

/**
 * @note This property has protected visibility in Kotlin source and is intended only for use by subclasses.
*/
@property (readonly) AnalyticsMutableDictionary<NSString *, id> *params __attribute__((swift_name("params")));
@property (readonly) AnalyticsVGSAnalyticsStatus *status __attribute__((swift_name("status")));

/**
 * @note This property has protected visibility in Kotlin source and is intended only for use by subclasses.
*/
@property (readonly) NSString *type __attribute__((swift_name("type")));
@end

__attribute__((objc_subclassing_restricted))
__attribute__((swift_name("VGSAnalyticsEvent.ContentSharing")))
@interface AnalyticsVGSAnalyticsEventContentSharing : AnalyticsVGSAnalyticsEvent
- (instancetype)initWithContentPath:(NSString *)contentPath __attribute__((swift_name("init(contentPath:)"))) __attribute__((objc_designated_initializer));
- (AnalyticsVGSAnalyticsEventContentSharing *)doCopyContentPath:(NSString *)contentPath __attribute__((swift_name("doCopy(contentPath:)")));
- (BOOL)isEqual:(id _Nullable)other __attribute__((swift_name("isEqual(_:)")));
- (NSUInteger)hash __attribute__((swift_name("hash()")));
- (NSString *)description __attribute__((swift_name("description()")));
@property (readonly) NSString *contentPath __attribute__((swift_name("contentPath")));

/**
 * @note This property has protected visibility in Kotlin source and is intended only for use by subclasses.
*/
@property (readonly) AnalyticsMutableDictionary<NSString *, id> *params __attribute__((swift_name("params")));

/**
 * @note This property has protected visibility in Kotlin source and is intended only for use by subclasses.
*/
@property (readonly) NSString *type __attribute__((swift_name("type")));
@end

__attribute__((objc_subclassing_restricted))
__attribute__((swift_name("VGSAnalyticsEvent.CopyToClipboard")))
@interface AnalyticsVGSAnalyticsEventCopyToClipboard : AnalyticsVGSAnalyticsEvent
- (instancetype)initWithFieldType:(NSString *)fieldType contentPath:(NSString *)contentPath format:(AnalyticsVGSAnalyticsCopyFormat *)format __attribute__((swift_name("init(fieldType:contentPath:format:)"))) __attribute__((objc_designated_initializer));
- (AnalyticsVGSAnalyticsEventCopyToClipboard *)doCopyFieldType:(NSString *)fieldType contentPath:(NSString *)contentPath format:(AnalyticsVGSAnalyticsCopyFormat *)format __attribute__((swift_name("doCopy(fieldType:contentPath:format:)")));
- (BOOL)isEqual:(id _Nullable)other __attribute__((swift_name("isEqual(_:)")));
- (NSUInteger)hash __attribute__((swift_name("hash()")));
- (NSString *)description __attribute__((swift_name("description()")));
@property (readonly) NSString *contentPath __attribute__((swift_name("contentPath")));
@property (readonly) NSString *fieldType __attribute__((swift_name("fieldType")));
@property (readonly) AnalyticsVGSAnalyticsCopyFormat *format __attribute__((swift_name("format")));

/**
 * @note This property has protected visibility in Kotlin source and is intended only for use by subclasses.
*/
@property (readonly) AnalyticsMutableDictionary<NSString *, id> *params __attribute__((swift_name("params")));

/**
 * @note This property has protected visibility in Kotlin source and is intended only for use by subclasses.
*/
@property (readonly) NSString *type __attribute__((swift_name("type")));
@end

__attribute__((objc_subclassing_restricted))
__attribute__((swift_name("VGSAnalyticsEvent.FieldAttach")))
@interface AnalyticsVGSAnalyticsEventFieldAttach : AnalyticsVGSAnalyticsEvent
- (instancetype)initWithFieldType:(NSString *)fieldType contentPath:(NSString * _Nullable)contentPath ui:(NSString * _Nullable)ui __attribute__((swift_name("init(fieldType:contentPath:ui:)"))) __attribute__((objc_designated_initializer));
- (AnalyticsVGSAnalyticsEventFieldAttach *)doCopyFieldType:(NSString *)fieldType contentPath:(NSString * _Nullable)contentPath ui:(NSString * _Nullable)ui __attribute__((swift_name("doCopy(fieldType:contentPath:ui:)")));
- (BOOL)isEqual:(id _Nullable)other __attribute__((swift_name("isEqual(_:)")));
- (NSUInteger)hash __attribute__((swift_name("hash()")));
- (NSString *)description __attribute__((swift_name("description()")));

/**
 * @note This property has protected visibility in Kotlin source and is intended only for use by subclasses.
*/
@property (readonly) AnalyticsMutableDictionary<NSString *, id> *params __attribute__((swift_name("params")));

/**
 * @note This property has protected visibility in Kotlin source and is intended only for use by subclasses.
*/
@property (readonly) NSString *type __attribute__((swift_name("type")));
@end

__attribute__((objc_subclassing_restricted))
__attribute__((swift_name("VGSAnalyticsEvent.FieldDetach")))
@interface AnalyticsVGSAnalyticsEventFieldDetach : AnalyticsVGSAnalyticsEvent
- (instancetype)initWithFieldType:(NSString *)fieldType __attribute__((swift_name("init(fieldType:)"))) __attribute__((objc_designated_initializer));
- (AnalyticsVGSAnalyticsEventFieldDetach *)doCopyFieldType:(NSString *)fieldType __attribute__((swift_name("doCopy(fieldType:)")));
- (BOOL)isEqual:(id _Nullable)other __attribute__((swift_name("isEqual(_:)")));
- (NSUInteger)hash __attribute__((swift_name("hash()")));
- (NSString *)description __attribute__((swift_name("description()")));

/**
 * @note This property has protected visibility in Kotlin source and is intended only for use by subclasses.
*/
@property (readonly) AnalyticsMutableDictionary<NSString *, id> *params __attribute__((swift_name("params")));

/**
 * @note This property has protected visibility in Kotlin source and is intended only for use by subclasses.
*/
@property (readonly) NSString *type __attribute__((swift_name("type")));
@end

__attribute__((objc_subclassing_restricted))
__attribute__((swift_name("VGSAnalyticsEvent.Request")))
@interface AnalyticsVGSAnalyticsEventRequest : AnalyticsVGSAnalyticsEvent
- (instancetype)initWithStatus:(AnalyticsVGSAnalyticsStatus *)status code:(int32_t)code content:(NSArray<NSString *> *)content __attribute__((swift_name("init(status:code:content:)"))) __attribute__((objc_designated_initializer));
- (instancetype)initWithStatus:(AnalyticsVGSAnalyticsStatus *)status code:(int32_t)code content:(NSArray<NSString *> *)content upstream:(AnalyticsVGSAnalyticsUpstream *)upstream __attribute__((swift_name("init(status:code:content:upstream:)"))) __attribute__((objc_designated_initializer));

/**
 * @note This property has protected visibility in Kotlin source and is intended only for use by subclasses.
*/
@property (readonly) AnalyticsMutableDictionary<NSString *, id> *params __attribute__((swift_name("params")));

/**
 * @note This property has protected visibility in Kotlin source and is intended only for use by subclasses.
*/
@property (readonly) NSString *type __attribute__((swift_name("type")));
@end

__attribute__((objc_subclassing_restricted))
__attribute__((swift_name("VGSAnalyticsEvent.RequestBuilder")))
@interface AnalyticsVGSAnalyticsEventRequestBuilder : AnalyticsBase
- (instancetype)initWithStatus:(AnalyticsVGSAnalyticsStatus *)status code:(int32_t)code upstream:(AnalyticsVGSAnalyticsUpstream *)upstream __attribute__((swift_name("init(status:code:upstream:)"))) __attribute__((objc_designated_initializer));
- (AnalyticsVGSAnalyticsEventRequest *)build __attribute__((swift_name("build()")));
- (AnalyticsVGSAnalyticsEventRequestBuilder *)customData __attribute__((swift_name("customData()")));
- (AnalyticsVGSAnalyticsEventRequestBuilder *)customHeader __attribute__((swift_name("customHeader()")));
- (AnalyticsVGSAnalyticsEventRequestBuilder *)customHostname __attribute__((swift_name("customHostname()")));
- (AnalyticsVGSAnalyticsEventRequestBuilder *)fields __attribute__((swift_name("fields()")));
- (AnalyticsVGSAnalyticsEventRequestBuilder *)files __attribute__((swift_name("files()")));
- (AnalyticsVGSAnalyticsEventRequestBuilder *)mappingPolicyPolicy:(AnalyticsVGSAnalyticsMappingPolicy *)policy __attribute__((swift_name("mappingPolicy(policy:)")));
- (AnalyticsVGSAnalyticsEventRequestBuilder *)pdf __attribute__((swift_name("pdf()")));
@end

__attribute__((objc_subclassing_restricted))
__attribute__((swift_name("VGSAnalyticsEvent.Response")))
@interface AnalyticsVGSAnalyticsEventResponse : AnalyticsVGSAnalyticsEvent
- (instancetype)initWithStatus:(AnalyticsVGSAnalyticsStatus *)status code:(int32_t)code errorMessage:(NSString * _Nullable)errorMessage __attribute__((swift_name("init(status:code:errorMessage:)"))) __attribute__((objc_designated_initializer));
- (instancetype)initWithStatus:(AnalyticsVGSAnalyticsStatus *)status code:(int32_t)code upstream:(AnalyticsVGSAnalyticsUpstream *)upstream errorMessage:(NSString * _Nullable)errorMessage __attribute__((swift_name("init(status:code:upstream:errorMessage:)"))) __attribute__((objc_designated_initializer));
- (AnalyticsVGSAnalyticsEventResponse *)doCopyStatus:(AnalyticsVGSAnalyticsStatus *)status code:(int32_t)code upstream:(AnalyticsVGSAnalyticsUpstream *)upstream errorMessage:(NSString * _Nullable)errorMessage __attribute__((swift_name("doCopy(status:code:upstream:errorMessage:)")));
- (BOOL)isEqual:(id _Nullable)other __attribute__((swift_name("isEqual(_:)")));
- (NSUInteger)hash __attribute__((swift_name("hash()")));
- (NSString *)description __attribute__((swift_name("description()")));

/**
 * @note This property has protected visibility in Kotlin source and is intended only for use by subclasses.
*/
@property (readonly) AnalyticsMutableDictionary<NSString *, id> *params __attribute__((swift_name("params")));

/**
 * @note This property has protected visibility in Kotlin source and is intended only for use by subclasses.
*/
@property (readonly) NSString *type __attribute__((swift_name("type")));
@end

__attribute__((objc_subclassing_restricted))
__attribute__((swift_name("VGSAnalyticsEvent.Scan")))
@interface AnalyticsVGSAnalyticsEventScan : AnalyticsVGSAnalyticsEvent
- (instancetype)initWithStatus:(AnalyticsVGSAnalyticsStatus *)status scanId:(NSString *)scanId scanDetails:(NSString *)scanDetails scannerType:(NSString *)scannerType __attribute__((swift_name("init(status:scanId:scanDetails:scannerType:)"))) __attribute__((objc_designated_initializer));
- (AnalyticsVGSAnalyticsEventScan *)doCopyStatus:(AnalyticsVGSAnalyticsStatus *)status scanId:(NSString *)scanId scanDetails:(NSString *)scanDetails scannerType:(NSString *)scannerType __attribute__((swift_name("doCopy(status:scanId:scanDetails:scannerType:)")));
- (BOOL)isEqual:(id _Nullable)other __attribute__((swift_name("isEqual(_:)")));
- (NSUInteger)hash __attribute__((swift_name("hash()")));
- (NSString *)description __attribute__((swift_name("description()")));

/**
 * @note This property has protected visibility in Kotlin source and is intended only for use by subclasses.
*/
@property (readonly) AnalyticsMutableDictionary<NSString *, id> *params __attribute__((swift_name("params")));
@property (readonly) NSString *scanDetails __attribute__((swift_name("scanDetails")));
@property (readonly) NSString *scanId __attribute__((swift_name("scanId")));
@property (readonly) NSString *scannerType __attribute__((swift_name("scannerType")));
@property (readonly) AnalyticsVGSAnalyticsStatus *status __attribute__((swift_name("status")));

/**
 * @note This property has protected visibility in Kotlin source and is intended only for use by subclasses.
*/
@property (readonly) NSString *type __attribute__((swift_name("type")));
@end

__attribute__((objc_subclassing_restricted))
__attribute__((swift_name("VGSAnalyticsEvent.SecureTextRange")))
@interface AnalyticsVGSAnalyticsEventSecureTextRange : AnalyticsVGSAnalyticsEvent
- (instancetype)initWithFieldType:(NSString *)fieldType contentPath:(NSString *)contentPath __attribute__((swift_name("init(fieldType:contentPath:)"))) __attribute__((objc_designated_initializer));
- (AnalyticsVGSAnalyticsEventSecureTextRange *)doCopyFieldType:(NSString *)fieldType contentPath:(NSString *)contentPath __attribute__((swift_name("doCopy(fieldType:contentPath:)")));
- (BOOL)isEqual:(id _Nullable)other __attribute__((swift_name("isEqual(_:)")));
- (NSUInteger)hash __attribute__((swift_name("hash()")));
- (NSString *)description __attribute__((swift_name("description()")));
@property (readonly) NSString *contentPath __attribute__((swift_name("contentPath")));
@property (readonly) NSString *fieldType __attribute__((swift_name("fieldType")));

/**
 * @note This property has protected visibility in Kotlin source and is intended only for use by subclasses.
*/
@property (readonly) AnalyticsMutableDictionary<NSString *, id> *params __attribute__((swift_name("params")));

/**
 * @note This property has protected visibility in Kotlin source and is intended only for use by subclasses.
*/
@property (readonly) NSString *type __attribute__((swift_name("type")));
@end

__attribute__((objc_subclassing_restricted))
__attribute__((swift_name("VGSAnalyticsMappingPolicy")))
@interface AnalyticsVGSAnalyticsMappingPolicy : AnalyticsKotlinEnum<AnalyticsVGSAnalyticsMappingPolicy *>
+ (instancetype)alloc __attribute__((unavailable));
+ (instancetype)allocWithZone:(struct _NSZone *)zone __attribute__((unavailable));
- (instancetype)initWithName:(NSString *)name ordinal:(int32_t)ordinal __attribute__((swift_name("init(name:ordinal:)"))) __attribute__((objc_designated_initializer)) __attribute__((unavailable));
@property (class, readonly) AnalyticsVGSAnalyticsMappingPolicy *nestedJson __attribute__((swift_name("nestedJson")));
@property (class, readonly) AnalyticsVGSAnalyticsMappingPolicy *flatJson __attribute__((swift_name("flatJson")));
@property (class, readonly) AnalyticsVGSAnalyticsMappingPolicy *nestedJsonArraysMerge __attribute__((swift_name("nestedJsonArraysMerge")));
@property (class, readonly) AnalyticsVGSAnalyticsMappingPolicy *nestedJsonArraysOverwrite __attribute__((swift_name("nestedJsonArraysOverwrite")));
+ (AnalyticsKotlinArray<AnalyticsVGSAnalyticsMappingPolicy *> *)values __attribute__((swift_name("values()")));
@property (class, readonly) NSArray<AnalyticsVGSAnalyticsMappingPolicy *> *entries __attribute__((swift_name("entries")));
@end

__attribute__((objc_subclassing_restricted))
__attribute__((swift_name("VGSAnalyticsStatus")))
@interface AnalyticsVGSAnalyticsStatus : AnalyticsKotlinEnum<AnalyticsVGSAnalyticsStatus *>
+ (instancetype)alloc __attribute__((unavailable));
+ (instancetype)allocWithZone:(struct _NSZone *)zone __attribute__((unavailable));
- (instancetype)initWithName:(NSString *)name ordinal:(int32_t)ordinal __attribute__((swift_name("init(name:ordinal:)"))) __attribute__((objc_designated_initializer)) __attribute__((unavailable));
@property (class, readonly) AnalyticsVGSAnalyticsStatus *ok __attribute__((swift_name("ok")));
@property (class, readonly) AnalyticsVGSAnalyticsStatus *failed __attribute__((swift_name("failed")));
@property (class, readonly) AnalyticsVGSAnalyticsStatus *canceled __attribute__((swift_name("canceled")));
+ (AnalyticsKotlinArray<AnalyticsVGSAnalyticsStatus *> *)values __attribute__((swift_name("values()")));
@property (class, readonly) NSArray<AnalyticsVGSAnalyticsStatus *> *entries __attribute__((swift_name("entries")));
- (NSString *)getAnalyticsName __attribute__((swift_name("getAnalyticsName()")));
@end

__attribute__((objc_subclassing_restricted))
__attribute__((swift_name("VGSAnalyticsUpstream")))
@interface AnalyticsVGSAnalyticsUpstream : AnalyticsKotlinEnum<AnalyticsVGSAnalyticsUpstream *>
+ (instancetype)alloc __attribute__((unavailable));
+ (instancetype)allocWithZone:(struct _NSZone *)zone __attribute__((unavailable));
- (instancetype)initWithName:(NSString *)name ordinal:(int32_t)ordinal __attribute__((swift_name("init(name:ordinal:)"))) __attribute__((objc_designated_initializer)) __attribute__((unavailable));
@property (class, readonly, getter=companion) AnalyticsVGSAnalyticsUpstreamCompanion *companion __attribute__((swift_name("companion")));
@property (class, readonly) AnalyticsVGSAnalyticsUpstream *tokenization __attribute__((swift_name("tokenization")));
@property (class, readonly) AnalyticsVGSAnalyticsUpstream *custom __attribute__((swift_name("custom")));
+ (AnalyticsKotlinArray<AnalyticsVGSAnalyticsUpstream *> *)values __attribute__((swift_name("values()")));
@property (class, readonly) NSArray<AnalyticsVGSAnalyticsUpstream *> *entries __attribute__((swift_name("entries")));
- (NSString *)getAnalyticsName __attribute__((swift_name("getAnalyticsName()")));
@end

__attribute__((objc_subclassing_restricted))
__attribute__((swift_name("VGSAnalyticsUpstream.Companion")))
@interface AnalyticsVGSAnalyticsUpstreamCompanion : AnalyticsBase
+ (instancetype)alloc __attribute__((unavailable));
+ (instancetype)allocWithZone:(struct _NSZone *)zone __attribute__((unavailable));
+ (instancetype)companion __attribute__((swift_name("init()")));
@property (class, readonly, getter=shared) AnalyticsVGSAnalyticsUpstreamCompanion *shared __attribute__((swift_name("shared")));
- (AnalyticsVGSAnalyticsUpstream *)getIsTokenization:(BOOL)isTokenization __attribute__((swift_name("get(isTokenization:)")));
@end

__attribute__((objc_subclassing_restricted))
__attribute__((swift_name("Session_iosKt")))
@interface AnalyticsSession_iosKt : AnalyticsBase
+ (NSString *)randomUUID __attribute__((swift_name("randomUUID()")));
@end

__attribute__((objc_subclassing_restricted))
__attribute__((swift_name("KotlinEnumCompanion")))
@interface AnalyticsKotlinEnumCompanion : AnalyticsBase
+ (instancetype)alloc __attribute__((unavailable));
+ (instancetype)allocWithZone:(struct _NSZone *)zone __attribute__((unavailable));
+ (instancetype)companion __attribute__((swift_name("init()")));
@property (class, readonly, getter=shared) AnalyticsKotlinEnumCompanion *shared __attribute__((swift_name("shared")));
@end

__attribute__((objc_subclassing_restricted))
__attribute__((swift_name("KotlinArray")))
@interface AnalyticsKotlinArray<T> : AnalyticsBase
+ (instancetype)arrayWithSize:(int32_t)size init:(T _Nullable (^)(AnalyticsInt *))init __attribute__((swift_name("init(size:init:)")));
+ (instancetype)alloc __attribute__((unavailable));
+ (instancetype)allocWithZone:(struct _NSZone *)zone __attribute__((unavailable));
- (T _Nullable)getIndex:(int32_t)index __attribute__((swift_name("get(index:)")));
- (id<AnalyticsKotlinIterator>)iterator __attribute__((swift_name("iterator()")));
- (void)setIndex:(int32_t)index value:(T _Nullable)value __attribute__((swift_name("set(index:value:)")));
@property (readonly) int32_t size __attribute__((swift_name("size")));
@end

__attribute__((swift_name("KotlinIterator")))
@protocol AnalyticsKotlinIterator
@required
- (BOOL)hasNext __attribute__((swift_name("hasNext()")));
- (id _Nullable)next __attribute__((swift_name("next()")));
@end

#pragma pop_macro("_Nullable_result")
#pragma clang diagnostic pop
NS_ASSUME_NONNULL_END
