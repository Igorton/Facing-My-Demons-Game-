/// @description Insert description here
// You can write your code in this editor

estado_idle = new estado();

estado_run = new estado();

estado_ataque = new estado();

estado_super_ataque = new estado();

estado_hit = new estado();

estado_morte = new estado();

meu_dano = noone;

dano_poise = 9;

max_vida = 5;
vida = max_vida;

imageindex = 0;

poise_max = 5;
poise = poise_max;

lida_dano = function(_dano = 1, _poise = 1){
	
	if(estado_atual == estado_morte) return;
	vida -= _dano;
	
	poise = max(poise - _poise, 0);
	
	if(vida <= 0){
		troca_estado(estado_morte);
		return;
	}
	
	if(poise <= 0 or estado_atual != estado_ataque){
		troca_estado(estado_hit);
	}
}


#region estado_idle
estado_idle.inicia = function(){
	sprite_index = spr_player_idle;
	image_index = 0;
}

estado_idle.roda = function(){
	if(up or down or left or right){
		troca_estado(estado_run);
	}
	if(attack){
		troca_estado(estado_ataque);
	}
	if(super_ataque){
		troca_estado(estado_super_ataque);
	}
	if(keyboard_check_released(ord("H"))){
		troca_estado(estado_hit);
	}
}

#endregion
#region estado_run
estado_run.inicia = function(){
	sprite_index = spr_player_run;
	
	image_index = 0;
}

estado_run.roda = function(){
	dir = (point_direction(0, 0, velh, velv) div 90);
	
	velv = (down - up) * velc;

	velh = (right - left) * velc;
	
	
	if(velh == 0 && velv == 0){
		troca_estado(estado_idle);
	}
	if(velh != 0)image_xscale = sign(velh);
	if(attack){
		troca_estado(estado_ataque);
	}
	if(super_ataque){
		troca_estado(estado_super_ataque);
	}
}
#endregion
#region estado_ataque
	estado_ataque.inicia = function()
	{
		sprite_index = spr_player_attack;
		image_index = 0;
		
		velh = 0;
		velv = 0;
		
		var _x = x + lengthdir_x(48, dir * 90);
		var _y = y + lengthdir_y(48, dir * 90);
		
		meu_dano = instance_create_depth(_x, _y, depth, obj_dano);
		audio_play_sound(snd_sword, 3, false);

		meu_dano.dano_poise = dano_poise;
		}
	
	estado_ataque.roda = function(){
		if(image_index >= image_number - 3.5){
			troca_estado(estado_idle);
		}
	}
	
	estado_ataque.finaliza = function(){
		instance_destroy(meu_dano);
	}
#endregion
#region estado_super_ataque
	estado_super_ataque.inicia = function(){
		sprite_index = spr_player_super_attack;
		image_index = 0;
		
		velh = 0;
		velv = 0;
		
		var _x = x + lengthdir_x(64, dir * 90);
		var _y = y + lengthdir_y(64, dir * 90);
		
		meu_dano = instance_create_depth(_x, _y, depth, obj_dano_especial);
		
		meu_dano.dano_poise = dano_poise;
	}
	estado_super_ataque.roda = function(){
		if(image_index >= image_number - 0.2){
			troca_estado(estado_idle);
		}
	}
#endregion
#region estado_hit
{
	estado_hit.inicia = function(){
		sprite_index = spr_player_hit;
		image_index = 0;
		
		velv = 0;
		velh = 0;
		obj_screen_shake.valor += 2;
		
		audio_play_sound(snd_player_hit, 3, false);
		
	}
	
	estado_hit.roda = function(){
		if(image_index >= image_number - .5){
			troca_estado(estado_idle);
		}
	}
}
#endregion
#region estado_morte
{
	estado_morte.inicia = function(){
		sprite_index = spr_player_death;
		image_index = 0;
		audio_stop_sound(snd_game);
		audio_play_sound(snd_gameover, 1, false);
		imageindex = 0;
		
	}
	
	estado_morte.roda = function(){
		if(image_index > imageindex){
			imageindex = image_index;
		}
		
		if(imageindex > image_index){
			image_index = image_number - 1;
			if(global.game_over == false){
			
				var _cam_x = camera_get_view_x(view_camera[0]);
				var _cam_y = camera_get_view_y(view_camera[0]);
			
				layer_sequence_create("Sequence", _cam_x, _cam_y, sq_morreu);
				global.game_over = true;
			}
		
		}
		//instance_destroy(obj_player);
	}
}
#endregion

up = noone;
down = noone;
left = noone;
right = noone;
attack = noone;
super_ataque = noone;

velh = 0;
velv = 0;

velc = 2.3;

dir = 0;

inicia_estado(estado_idle);