//
//  TipolabViewController.m
//  reservaLCOMS
//
//  Created by cristian castillo on 5/20/18.
//  Copyright © 2018 cristian castillo. All rights reserved.
//

#import "TipolabViewController.h"
#import "controlBD.h"

@interface TipolabViewController ()
{
NSMutableArray *arrayTipolab;
sqlite3 *reservaBD;
NSString *dbPathString;
}
@end

@implementation TipolabViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    [[controlBD sharedInstance] crearOabrirBD];
    arrayTipolab=[[NSMutableArray alloc]init];
    [[self TipolabTableView]setDelegate:self];
    [[self TipolabTableView]setDataSource:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [arrayTipolab count];
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier=@"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if(!cell){
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier: CellIdentifier];
    }
    
    TipoLab *tTipolab=[arrayTipolab objectAtIndex:indexPath.row];
    cell.textLabel.text=tTipolab.idTipoLab;
    cell.detailTextLabel.text=[NSString stringWithFormat:@"%@ %@",tTipolab.nombre,tTipolab.procesador];
    return cell;
}


- (IBAction)InsertarTipolabBoton:(id)sender {
        char *error;
        if(sqlite3_open([[controlBD sharedInstance].dbPath UTF8String], &reservaBD)==SQLITE_OK) {
            NSString *insert_Stmt=[NSString stringWithFormat:@"INSERT INTO TIPOLAB(IDTIPOLAB, NOMBRE, RAM, SISTEMASOPE, CAPACIDADDISCO,PROCESADOR) values('%s', '%s', '%s', '%s', '%s', '%s')",[self.idTipoLabField.text UTF8String ], [self.nombreField.text UTF8String],[self.ramField.text UTF8String], [self.sistemasOpeField.text UTF8String], [self.capacidadDiscoField.text UTF8String], [self.procesadorField.text UTF8String]];
            const  char *insert_stmt=[insert_Stmt UTF8String];
            
            if(sqlite3_exec(reservaBD, insert_stmt, NULL, NULL, &error)==SQLITE_OK){
                NSLog(@"TipoLaboratorio Insertado correctamente");
                
                TipoLab *tipolab =[[TipoLab alloc]init];
                [tipolab setIdTipoLab:self.idTipoLabField.text];
                [tipolab setNombre:self.nombreField.text ];
                [tipolab setRam:self.ramField.text];
                [tipolab setSistemasOpe:self.sistemasOpeField.text];
                [tipolab setCapacidadDisco:self.capacidadDiscoField.text];
                [tipolab setProcesador:self.procesadorField.text ];
                [arrayTipolab addObject:tipolab];
                
                
                
            }
            else {
                NSLog(@" Registro no insertado");
            }
            sqlite3_close(reservaBD);
        }
    }


- (IBAction)ActualizarTipolabBoton:(id)sender {
    
    static sqlite3_stmt *statement=nil;
    if(sqlite3_open([[controlBD sharedInstance].dbPath UTF8String], &reservaBD)==SQLITE_OK){
        char *update_Stmt="UPDATE TIPOLAB SET NOMBRE=?, RAM=?, SISTEMASOPE=?, CAPACIDADDISCO=?, PROCESADOR=? WHERE IDTIPOLAB=?";
        if(sqlite3_prepare_v2(reservaBD, update_Stmt, -1, &statement, NULL)==SQLITE_OK){
            sqlite3_bind_text(statement, 1,[self.nombreField.text UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_bind_text(statement, 2,[self.ramField.text UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_bind_text(statement, 3,[self.sistemasOpeField.text UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_bind_text(statement, 4,[self.capacidadDiscoField.text UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_bind_text(statement, 5,[self.procesadorField.text UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_step(statement);
            TipoLab *tipolab =[[TipoLab alloc]init];
            [tipolab setIdTipoLab:self.idTipoLabField.text];
            [tipolab setNombre:self.nombreField.text];
            [tipolab setRam:self.ramField.text];
            [tipolab setSistemasOpe:self.sistemasOpeField.text];
            [tipolab setCapacidadDisco:self.capacidadDiscoField.text];
            [tipolab setProcesador:self.procesadorField.text ];
            [arrayTipolab addObject: tipolab];
            NSLog(@" Tipo de Lab Modifcado modificada");
            
            
            
        }
        else
        {
            NSLog(@"Tipo Lab no modificado");
        }
        sqlite3_close(reservaBD);
    }

}

- (IBAction)SeleccionarTipolabBoton:(id)sender {
    sqlite3_stmt *statement;
    if(sqlite3_open([[controlBD sharedInstance].dbPath UTF8String], &reservaBD)==SQLITE_OK){
        [arrayTipolab removeAllObjects];
        NSString *querySql =[NSString stringWithFormat:@"SELECT * FROM TIPOLAB"];
        const char *querysql=[querySql UTF8String];
        
        if(sqlite3_prepare(reservaBD, querysql, -1, &statement, NULL)==SQLITE_OK){
            while (sqlite3_step(statement)==SQLITE_ROW){
                
                NSString *idTipoLab1= [[NSString alloc ] initWithUTF8String:(const char *) sqlite3_column_text(statement,0)];
                NSString *nombre1= [[NSString alloc ] initWithUTF8String:(const char *) sqlite3_column_text(statement,1)];
                NSString *ram1= [[NSString alloc ] initWithUTF8String:(const char *) sqlite3_column_text(statement,2)];
                NSString *sistemasOpe1= [[NSString alloc ] initWithUTF8String:(const char *) sqlite3_column_text(statement,3)];
                NSString *capacidadDisco1= [[NSString alloc ] initWithUTF8String:(const char *) sqlite3_column_text(statement,4)];
                NSString *procesador1= [[NSString alloc ] initWithUTF8String:(const char *) sqlite3_column_text(statement,5)];
                
                TipoLab *tipolab =[[TipoLab alloc]init];
                [tipolab setIdTipoLab:idTipoLab1];
                [tipolab setNombre:nombre1];
                [tipolab setRam:ram1];
                [tipolab setSistemasOpe:sistemasOpe1];
                [tipolab setCapacidadDisco:capacidadDisco1];
                [tipolab setProcesador:procesador1];
                [arrayTipolab addObject:tipolab];
                
                
                
            }
        }
        else{
            NSLog(@"Lista vacia");
        }
        sqlite3_close(reservaBD);
        
    }
    [[self TipolabTableView]reloadData];
}



- (IBAction)EliminarTipolabBoton:(id)sender {
    [[self TipolabTableView]setEditing:!self.TipolabTableView.editing animated:YES];
    
}

-(void)deleteData:(NSString *)deleteQuery
{
    char * error;
    if (sqlite3_open([[controlBD sharedInstance].dbPath UTF8String], &reservaBD)==SQLITE_OK) {
        if(sqlite3_exec(reservaBD, [deleteQuery UTF8String], NULL, NULL, &error)==SQLITE_OK){
            NSLog(@" TipoLab Eliminada");
            
        }
        else{
            NSLog(@"TipoLab No Eliminada");
        }
        sqlite3_close(reservaBD);
    }
       }
       
       -(void) tableView:(UITableView *) tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
           if(editingStyle==UITableViewCellEditingStyleDelete){
               TipoLab *tlab =[arrayTipolab objectAtIndex:indexPath.row];
               [self deleteData:[NSString stringWithFormat:@"DELETE FROM TIPOLAB WHERE IDTIPOLAB IS '%s'",[tlab.idTipoLab UTF8String]]];
               [arrayTipolab removeObjectAtIndex: indexPath.row];
               [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation: UITableViewRowAnimationFade];
           }
           
       }
       
       
       -(void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
           [super touchesBegan: touches withEvent:event];
           [[self idTipoLabField]resignFirstResponder];
           [[self nombreField] resignFirstResponder];
           [[self ramField] resignFirstResponder];
           [[self sistemasOpeField] resignFirstResponder];
           [[self capacidadDiscoField] resignFirstResponder];
           [[self procesadorField] resignFirstResponder];
           
           
       }
       
       
       
       
       @end
    
