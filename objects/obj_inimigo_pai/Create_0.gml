/// @description Insert description here
// You can write your code in this editor

xscale = 1;

poise = poise_max;

lida_dano = function(_dano = 1, _poise = 1){
	vida -= _dano;
	
	poise = max(poise - _poise, 0);
	
	if(poise <= 0 or estado_atual != estado_attack){
		troca_estado(estado_hit);
	}
}

estado_idle = new estado();
estado_attack = new estado();
estado_run = new estado();
estado_hit = new estado();
estado_dead = new estado();

inicia_estado(estado_idle);