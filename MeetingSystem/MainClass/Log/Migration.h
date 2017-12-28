//
//  Migration.h
//  FMDBMigrationManager
//
//  Created by Alan on 2017/2/8.
//  Copyright © 2017年 Alan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <FMDBMigrationManager/FMDBMigrationManager.h>

@interface Migration : NSObject<FMDBMigrating>
//自定义方法
- (instancetype)initWithName:(NSString *)name andVersion:(uint64_t)version andExecuteUpdateArray:(NSArray *)updateArray;

@property (nonatomic, readonly) NSString *name;
@property (nonatomic, readonly) uint64_t version;

- (BOOL)migrateDatabase:(FMDatabase *)database error:(out NSError *__autoreleasing *)error;
@end
