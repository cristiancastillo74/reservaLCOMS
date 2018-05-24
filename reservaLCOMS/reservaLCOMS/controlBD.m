//
//  controlBD.m
//  reservaLCOMS
//
//  Created by cristian castillo on 5/20/18.
//  Copyright © 2018 cristian castillo. All rights reserved.
//

#import "controlBD.h"


@interface controlBD(){
    sqlite3 *reservaBD;
    NSString *dbPathString;
}

@end

@implementation controlBD

+(controlBD *) sharedInstance{
    static controlBD *myInstance=nil;
    // chect to see if an instance already exists
    if (nil == myInstance) {
        myInstance = [[[self class] alloc] init];
    }
    // return the instance of this class
    return myInstance;
}

-(void) crearOabrirBD
{
    NSArray *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docPath = [path objectAtIndex:0];
    dbPathString = [docPath stringByAppendingPathComponent:@"carnet1.db"];
    char *error;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:dbPathString]) {
        const char *dbPath = [dbPathString UTF8String];
        // crear la base de datos
        if (sqlite3_open(dbPath, &reservaBD) == SQLITE_OK) {
            NSString *foreign = @"PRAGMA foreign_keys = ON";
            const char *foreign1 = [foreign UTF8String];
            if (sqlite3_exec(reservaBD, foreign1, NULL, NULL, &error) != SQLITE_OK) {
                NSLog(@"failed to set the foreign_key pragma");
                return;
            }
            const char *sql_stmt = "create table profesor(idProfesor varchar(10) not null primary key, nombre varchar(10) not null);";
            
            sqlite3_exec(reservaBD, sql_stmt, NULL, NULL, &error);

            //CREACION DE TABLA RESERVACION
            sql_stmt="create table reservacion(idReservacion varchar(10) not null primary key, idprofesor varchar(10) not null, codAsignatura varchar(10) not null, codLab varchar(10) not null, idHorario varchar(10) not null, idDia varchar(10) not null);";
            sqlite3_exec(reservaBD, sql_stmt, NULL, NULL, &error);
            //CREACION DE TABLA MATERIA
            sql_stmt="create teable asignatura(codAsignatura varchar(10) not null primary key, nombre varchar(10) not null, ciclo varchar(10) not null);";
            sqlite3_exec(reservaBD, sql_stmt, NULL, NULL, &error);
            //CREACION DE TABLA TIPO LABORATORIO
            sql_stmt="create table tipoLab(idTipoLab varchar(10) not null primary key,nombre varchar(10) not null,ram varchar(10) not null,sistemasOpe varchar(10) not null,capacidadDisco varchar(10) not null,procesador varchar(10) not null);";
            

            sqlite3_exec(reservaBD, sql_stmt, NULL, NULL, &error);
            sqlite3_close(reservaBD);
            _dbPath = dbPathString;
            return;
        }
    }
    const char *dbPath = [dbPathString UTF8String];
    //crear la base de datos
    if (sqlite3_open(dbPath, &reservaBD) == SQLITE_OK) {
        _dbPath = dbPathString;
    }
}

@end

