import { NgModule } from '@angular/core';
import { CommonModule } from '@angular/common';
import {RouterModule, Routes} from "@angular/router";
import {RoomlistComponent} from "../roomlist/roomlist.component";
import {RoomComponent} from "../roomlist/room/room.component";
import {PageNotFoundComponent} from "../page-not-found/page-not-found.component";

const appRoutes: Routes = [
  { path: 'room-list', component: RoomlistComponent },
  { path: 'room/:id', component: RoomComponent },
  { path: '', redirectTo: '/room-list', pathMatch: 'full' },
  { path: '**', component: PageNotFoundComponent }
]

@NgModule({
  declarations: [],
  imports: [
    CommonModule,
    RouterModule.forRoot(
      appRoutes
    )
  ],
  exports: [
    RouterModule
  ]
})
export class AppRoutingModule {}
