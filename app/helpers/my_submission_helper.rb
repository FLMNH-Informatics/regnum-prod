module MySubmissionHelper
	def html_characters_list
  	%w{
	  	&nabla;
		&Agrave;
		&Aacute;
		&Acirc;
		&Atilde;
		&Auml;
		&Aring;
		&AElig;
		&Ccedil;
		&Egrave;
		&Eacute;
		&Ecirc;
		&Euml;
		&Igrave;
		&Iacute;
		&Icirc;
		&Iuml;
		&ETH;
		&Ntilde;
		&Ograve;
		&Oacute;
		&Ocirc;
		&Otilde;
		&Ouml;
		&times;
		&Oslash;
		&Ugrave;
		&Uacute;
		&Ucirc;
		&Uuml;
		&Yacute;
		&THORN;
		&szlig;
		&agrave;
		&aacute;
		&acirc;
		&atilde;
		&auml;
		&aring;
		&aelig;
		&ccedil;
		&egrave;
		&eacute;
		&ecirc;
		&euml;
		&igrave;
		&iacute;
		&icirc;
		&iuml;
		&eth;
		&ntilde;
		&ograve;
		&oacute;
		&ocirc;
		&otilde;
		&ouml;
		&divide;
		&oslash;
		&ugrave;
		&uacute;
		&ucirc;
		&uuml;
		&yacute;
		&thorn;
		&yuml;
		&Scaron;
		&scaron;
		&tilde;
		&Alpha;
		&Beta;
		&Gamma;
		&Delta;
		&Epsilon;
		&Zeta;
		&Eta;
		&Theta;
		&Iota;
		&Kappa;
		&Lambda;
		&Mu;
		&Nu;
		&Xi;
		&Omicron;
		&Pi;
		&Rho;
		&Sigma;
		&Tau;
		&Upsilon;
		&Phi;
		&Chi;
		&Psi;
		&Omega;
		&alpha;
		&beta;
		&gamma;
		&delta;
		&epsilon;
		&zeta;
		&eta;
		&theta;
		&iota;
		&kappa;
		&lambda;
		&mu;
		&nu;
		&xi;
		&omicron;
		&pi;
		&rho;
		&sigmaf;
		&sigma;
		&tau;
		&upsilon;
		&phi;
		&chi;
		&psi;
		&omega;
		&thetasym;
		&upsih;
		&piv;
		&#370;
  	}
	end

	def special_characters_template
    out = '<table>'
    html_characters_list.each_slice(10) do |slice|
    	out << '<tr style="text-align:center;font-weight:bold;">'
      slice.each do |char|
        out << "<td>#{char}</td>"
      end
    	out << '</tr><tr>'
      slice.each do |char|
        out << "<td><input class=\"character-button\" type=\"button\" value=\"#{char}\" /></td>"
      end     
      out << '</tr>'
    end
    out << '</table>'
    raw out
	end
end
