/// @description Insert description here
// You can write your code in this editor

// Inherit the parent event

tempo_estado = game_get_speed(gamespeed_fps) * 15;
timer_estado = tempo_estado;

destino_x = 0;
destino_y = 0;

dano = noone;
dano_valor = 3;

estado_chase = new estado();

alvo = noone;

event_inherited();

#region estado_idle
{
	estado_idle.inicia = function(){
		sprite_index = spr_demon_idle;
		
		image_index = 0;
		
		timer_estado = tempo_estado;
	}
	estado_idle.roda = function(){
		timer_estado--;
		var _tempo  = irandom(timer_estado);
		
		if(_tempo <= tempo_estado * .01){
			var _estado_novo = choose(estado_idle, estado_run);
			troca_estado(_estado_novo);
		}
	}
}

#endregion
#region estado_run
{
	estado_run.inicia = function(){
		sprite_index = spr_demon_run;
		image_index = 0;
		
		timer_estado = tempo_estado;
		
		destino_x = irandom(room_width);
		destino_y = irandom(room_height);
		
		xscale = sign(destino_x - x);
	}
	
	estado_run.roda = function(){
		timer_estado--;
		
		var _tempo  = irandom(timer_estado);
		
		if(_tempo <= 5){
			var _estado_novo = choose(estado_idle, estado_run);
			
			//troca_estado(_estado_novo);
		}
		if(instance_exists(obj_player)){
			if distance_to_object(obj_player) < 300 or alvo != noone{
				mp_potential_step_object(obj_player.x, obj_player.y, 1, obj_colisor);
		
				var _dist = point_distance(x, y, obj_player.x, obj_player.y);
		
				xscale = sign(x - obj_player.x);
		
				if(_dist <= 50){
					troca_estado(estado_attack);
				}
				alvo = obj_player;
			}else{
				mp_linear_step_object(destino_x, destino_y, 1, obj_colisor);
				xscale = sign(x - destino_x);
				alvo = noone;
			}
		}else{
			mp_linear_step_object(destino_x, destino_y, 1, obj_colisor);
			xscale = sign(x - destino_x);
			alvo = noone;
		}
	}
}
#endregion
#region estado_attack
{
	estado_attack.inicia = function(){
		sprite_index = spr_demon_attack;
		image_index = 0;
	}
	
	estado_attack.roda = function(){
		if(dano == noone && image_index >= 1 && instance_exists(obj_player)) && obj_player.estado_atual != obj_player.estado_morte{
			dano = instance_create_depth(x, y, depth, obj_dano_inimigo);
			dano.dano = dano_valor;
		}

		
		if(image_index >= image_number - 0.5){
			troca_estado(estado_run);
		}
	}
	estado_attack.finaliza = function(){
		if(instance_exists(dano)){
			instance_destroy(dano);
		}
		dano = noone;
	}
}
#endregion
#region estado_hit
{
	estado_hit.inicia = function(){
		sprite_index = spr_demon_hit;
		image_index = 0;
		
		//obj_screen_shake.valor += 5;
		
		obj_screen_shake.ang += 2;
		audio_play_sound(snd_monster, 3, false);
	}
	estado_hit.roda = function(){
		if(image_index >= image_number - 0.5){
			if(vida > 0){
				troca_estado(estado_run);
			}else{
				troca_estado(estado_dead);
			}
		}
	}
}
#endregion
#region estado_dead
{
	estado_dead.inicia = function(){
		sprite_index = spr_demon_death;
		image_index = 0;
		audio_play_sound(snd_monster_dead, 1, false);
	}
	estado_dead.roda = function(){
		if(image_index >= image_number - 1){
			instance_destroy();
		}
	}
}
#endregion

//#region estado_chase
//{
//	estado_chase.inicia = function(){
//		sprite_index = spr_demon_run;
//		image_index = 0;
//		
//		if(instance_exists(obj_player)){
//			alvo = obj_player.id;
//		}
//	}
//	
//	estado_chase.roda = function(){
//		if(!instance_exists(obj_player)){
//			alvo = noone;
//			troca_estado(estado_idle);
//		}
//		mp_potential_step_object(alvo.x, alvo.y, 1, obj_colisor);
//	}
//}
//#endregion

inicia_estado(estado_idle);
