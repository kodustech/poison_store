**FREE
dcl-s nome char(20) inz('Kody');
dcl-s versao packed(3:1) inz(1.0);

dsply ('Sistema: ' + %trim(nome));

*inlr = *on;