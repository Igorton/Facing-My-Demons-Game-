/// @description Insert description here
// You can write your code in this editor
draw_set_font(fnt_gameover);
draw_set_color(c_white);

for(var i =0 ;i< op_max; i++){
    draw_text(30,30+(30*i),opcoes[i]);
}


draw_set_font(-1);