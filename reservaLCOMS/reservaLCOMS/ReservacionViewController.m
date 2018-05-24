//
//  ReservacionViewController.m
//  reservaLCOMS
//
//  Created by cristian castillo on 5/20/18.
//  Copyright © 2018 cristian castillo. All rights reserved.
//

#import "ReservacionViewController.h"
#import "controlBD.h"

@interface ReservacionViewController()
{ NSMutableArray *arrayReservacion;
    sqlite3 *reservacionDB;
    NSString *dbPathString;
}
@end

@implementation ReservacionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [[controlBD sharedInstance] crearOabrirBD];
    arrayReservacion=[[NSMutableArray alloc ]init];
    [[self ReservacionTableView]setDelegate:self];
    [[self ReservacionTableView]setDataSource:self];
    
    // Do any additional setup after loading the view.
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [arrayReservacion count];
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier=@"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if(!cell){
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier: CellIdentifier];
    }
    
    Reservacion *rReservacion=[arrayReservacion objectAtIndex:indexPath.row];
    cell.textLabel.text==rReservacion.idReservacion;
    [NSString stringWithFormat:@"%@ %@", rReservacion.idHorario, rReservacion.idprofesor];
    return cell;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)insertarReservacionBoton:(id)sender {
    char *error;
    if(sqlite3_open([[controlBD shareInstance].dbPath UTF8String], &reservaBD)==SQLITE_OK) {
        NSString *insert_Stmt=[NSString stringWithFormat: @"INSERT INTO RESERVACION(IDRESERVACION, IDPROFESOR, CODASIGNATURA, CODLAB, IDHORARIO, ,IDDIA) values('%s', '%s', '%s', '%s', '%s', '%s')",[self.idReservacionField.text UTF8String ], [self.idProfesorField.text UTF8String],[self.codAsignaturaField.text UTFString], [self.codLabField.text UTFString], [self.idHorarioField.text UTFString], [self.codIdDiaField.text UTFString]];
        const  char *insert_stmt=[insert_Stmt UTFString];
        
        if(sqlite3_exec(reservacionDB, insert_stmt, NULL, NULL, &error)==SQLITE_OK){
            NSlog (@"Reservacion Insertada correctamente");
            
            Reservacion *reservacion =[[Reservacion alloc]init];
            [reservacion setIdReservacion:self.idReservacionField.text];
            [reservacion setIdProfesor:self.idProfesorField.text ];
            [reservacion setCodAsignatura:self.codAsignaturaField.text];
            [reservacion setCodLab:self.codLabField.text];
            [reservacion setIdHorario:self.idHorarioField.text];
            [reservacion setIdDia:self.codIdDiaField.text ];
            [arrayReservacion addObject:reservacion];
            
            
            
        }
        else {
            NSLog(@" Registro no insertado");
        }
        sqlite3_close(reservaBD);
    }
}

- (IBAction)consultarReservacionBoton:(id)sender {
    sqlite3_stmt *statement;
    if(sqlite3_open([[controlDB shareInstance].dbPath UTF8String], &reservaBD)==SQLITE_OK){
        [arrayReservacion removeAllObjects];
        NSString *querySql =[NSString stringWithFormat:@"SELECT * FROM RESERVACION"];
        const char *querysql=[querysql UTF8String];
        
        if(sqlite3_prepare(reservaBD, querysql, -1, &statement, NULL)==SQLITE_OK){
            while (sqlite3_step(statement)==SQLITE_ROW){
                
                NSString *idReservacion1= [[NSString alloc ] initWithUTF8String:(const char *) sqlite3_column_text(statement,0)];
                NSString *idProfesor1= [[NSString alloc ] initWithUTF8String:(const char *) sqlite3_column_text(statement,1)];
                NSString *codLab1= [[NSString alloc ] initWithUTF8String:(const char *) sqlite3_column_text(statement,2)];
                NSString *idHorario1= [[NSString alloc ] initWithUTF8String:(const char *) sqlite3_column_text(statement,3)];
                NSString *idDia1= [[NSString alloc ] initWithUTF8String:(const char *) sqlite3_column_text(statement,4)];
                
                Reservacion *reservacion =[[Reservacion alloc]unit];
                [reservacion setIdReservacion:idReservacion1];
                [reservacion setIdProfesor:idProfesor1];
                [reservacion setCodAsignatura:idHorario1];
                [reservacion setCodLab:codLab1];
                [reservacion setIdHorario:idHorario1];
                [reservacion setIdDia:idDia1];
                [arrayReservacion addObject:reservacion];
                
                
                
            }
        }
        else{
            NSLog(@"Lista vacia");
        }
        sqlite3_close(reservaBD);
        
    }
    [[self ReservacionesTableView]reloadData];
}

- (IBAction)actualizarReservacionBoton:(id)sender {
    
    
    static sqlite3_stmt *statement=nil;
    if(sqlite3_open([[controlBD shareInstance].dbPath UTF8String],&reservaBD)==SQLITE_OK){
        char *update_Stmt="UPDATE RESERVACION SET IDPROFESOR=?, CODASIGNATURA=?, CODLAB=?, IDHORARIO=?, IDDIA=? WHERE IDRESERVACION=?";
        if(sqlite3_prepare_v2(reservaBD, update_Stmt, -1, &statement, NULL)==SQLITE_OK){
            sqlite3_bind_text(statement, 1,[self.idProfesorField.text UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_bind_text(statement, 2,[self.codAsignaturaField.text UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_bind_text(statement, 3,[self.codLabField.text UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_bind_text(statement, 4,[self.idHorarioField.text UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_bind_text(statement, 5,[self.codIdDiaField.text UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_step(statement);
            Reservacion *reservacion =[[Reservacion alloc]init];
            [reservacion setIdReservacion:self.idReservacionField.text];
            [reservacion setIdProfesor:self.idProfesorField.text ];
            [reservacion setCodAsignatura:self.codAsignaturaField.text];
            [reservacion setCodLab:self.codLabField.text];
            [reservacion setIdHorario:self.idHorarioField.text];
            [reservacion setIdDia:self.codIdDiaField.text ];
            [arrayReservacion addObject: reservacion];
            NSLog(@" Reservacion modificada");
            
            
        
        }
        else
        {
            NSlog(@"Alumno no modificado");
        }
        sqlite3_close(reservaBD);
    }
}

- (IBAction)eliminarReservacionBoton:(id)sender {
    [[self ReservacionesTableView]setEditing:!self.ReservacionesTableView.editing animated:YES];
    
}

-(void)deleteData:(NSString *)deleteQuery
{
    char * error;
    if[(sqlite3_open([reservaBD shareInstance].dbPath UTF8String), &reservaDB)==SQLITE_OK){
        if(sqlite3_exec(reservaBD, [deleteQuery UTF8String], NULL, NULL, &error)==SQLITE_OK){
            NSLog(@" Reserva Eliminada");
            
        }
        else{
            NSLog(@"Reserva No Eliminada");
        }
        sqlite3_close(reservaBD);
    }
}
        
       -(void) tableView:(UITableView *) tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath: NSIndexPath *)indexPath{
           if(editingStyle==UITableViewCellEditingStyleDelete){
               Reservacion *reser =[arrayReservacion objectAtIndex:indexPath.row];
               [self deleteData:[NSString stringWithFormat:@"DELETE FROM RESERVACION WHERE IDRESERVACION ID '%s'",[reser.idReservacion UTF8String]]];
               [arrayReservacion removeObjectAtIndex: indexPath.row];
               [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation: UITableViewRowAnimationFade];
           }
           
       }
       
       
       -(void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
           [super touchesBegan: touches withEvent:event];
           [[self idReservacionField] reseignFirstResponder];
           [[self idProfesorField] reseignFirstResponder];
           [[self idReservacionField] reseignFirstResponder];
           [[self idReservacionField] reseignFirstResponder];
           [[self idReservacionField] reseignFirstResponder];
           
           
       }
       
       
       
        
@endidReservacionField.text
