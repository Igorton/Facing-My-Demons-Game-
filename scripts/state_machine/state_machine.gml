// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
function estado() constructor
{
	static inicia = function(){};
	
	static roda = function(){};
	
	static finaliza = function(){};
	
}

function inicia_estado(_estado){
	estado_atual = _estado;
	
	estado_atual.inicia();
}

function roda_estado(){
	estado_atual.roda();
}

function troca_estado(_estado){
	estado_atual.finaliza();
	
	estado_atual = _estado;
	estado_atual.inicia();
}