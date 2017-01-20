var replacements = [
  ["bdd",["bdd","behavio(u?)r(.?)driven(.?)development"]],
  ["backlog",["backlog","carnet de produit","carnet de sprint"]],
  ["timebox",["timebox","bo(.?)te de temps"]],
  ["autouild",["build","build automatis(.?)"]],
  ["crc",["crc card(s?)","carte(s?) crc"]],
  ["3c",["cart(e|on), conversation, confirmation"]],
  ["3c",["cart(e|on), conversation, confirmation"]],
  ["charter",["charte projet"]],
  ["quickdesign",["quick design session"]],
  ["yagni",["yagni","conception simple","conception (.?)mergente"]],
  ["simplicite",["(r(.?)gles|crit(.?)eres) de simplicit(.?)"]],
  ["split",["splitter","d(.?)coup(er|age)"]],
  ["ready",["d(.?)finition de (.?)pr(.?)t(.?)"]],
  ["sashimi",["\\bdod\\b","d(.?)finition de (.?)fini(.?)","d(.?)finition du (.?)done(.?)"]],
  ["ready",["d(.?)finition de (.?)pr(.?)t(.?)"]],
  ["cd",["d(.?)ploiement continu"]],
  ["incremental",["incr(.?)mental(e?)(s?)"]],
  ["iterative",["it(.?)ratif"]],
  ["tdd",["\\btdd","d(.?)veloppement par les tests","pilot(.?) par les tests","test(.?)driven"]],
  ["atdd",["\\batdd","d(.?)veloppement par les tests client","pilot(.?) par les tests client"]],
  ["grooming",["grooming","entretien du backlog"]],
  ["team",["(.?)quipe agile"]],
  ["estimation",["technique(s?) d'estimation"]],
  ["relative",["estimation(s?) relative(s?)"]],
  ["facilitation",["facilitation","facilitateur","r(.?)union facilit(.?)e"]],
  ["versioncontrol",["gestion de(s?) versions","source control"]],
  ["gwt",["given(.?)when(.?)then"]],
  ["burndown",["beurdone","burn(.?)down"]],
  ["invest",["\\binvest\\b"]],
  ["ci",["int(.?)gration continue","continuous integration"]],
  ["iteration",["it(.?)ration(s?)","sprint(s?)"]],
  ["smallrelease",["livraisons fr(.?)quentes","petites livraisons"]],
  ["nikoniko",["niko(.?)niko"]],
  ["mocks",["mock objects","mock(s?)"]],
  ["personas",["persona(s?)"]],
  ["poker",["planning poker"]],
  ["nuts",["\\bnuts\\b","story points","points de story"]],
  ["pairing",["pair programming","bin(.?)mage","en bin(.?)me(s?)"]],
  ["radiator",["bvc","radiateur(s?) d'information","big visible chart"]],
  ["refactoring",["refactoring","remaniement"]],
  ["cco",["responsabilit(.?) collective","code ownership"]],
  ["sustainable",["rythme soutenable","sustainable pace"]],
  ["retro",["r(.?)trospective de projet"]],
  ["heartbeatretro",["r(.?)trospective"]],
  ["daily",["r(.?)union(s?) quotidienne(s?)","daily scrum(s?)"]],
  ["teamroom",["team room","war room","salle d(.?)di(.?)e"]],
  ["scrumofscrums",["scrum de scrums"]],
  ["storymap",["story mapping"]],
  ["taskboard",["taskboard","task board","tableau des t(.?)ches"]],
  ["kanban",["kanban"]],
  ["leadtime",["lead time","temps de cycle"]],
  ["usability",["test d'utilisabilit(.?)","test d'usabilit(.?)"]],
  ["exploratory",["test exploratoire"]],
  ["acceptance",["test(s?) de recette","test(s?) d'acceptance", "test(s?) fonctionnel(s?)","test(s?) client"]],
  ["unittest",["test(s?) unitaire(s?)","test(s?) d(.?)veloppeur", "test(s?) automatis(.?)(s?)"]],
  ["stories",["user stories","user story"]],
  ["velocity",["v(.?)locit(.?)"]]
];
var base = "http://referentiel.institut-agile.fr/";

// Core functions

function wrap(text, before, after) {
  return before+text+after;
}

function wrapWith(jQuery, element, keywords, destination, wrapper) {
  callWrapper = function(matched) { return wrapper(matched,destination)};
  jQuery(element).replaceText( new RegExp(keywords.join("|"),"gi"), callWrapper);
}

function wrapAll(jquery, element, spec, wrapper) {
  jquery.each(spec, function(i,pair) {
    wrapWith(jquery,element,pair[1],pair[0],wrapper);
  });
}

function dictionaryLink(matched, destination, base) {
  return "<a target='_blank' rel='"+destination+"' href='"+base+destination+".html' class='highlighted'>"+matched+"</a>"
}

// jQuery and CSS loading

function loadJQuery(req_version, callback) {
  var done = false;
  // If jQuery isn't loaded, or is a lower version than specified, load the
  // specified version and call the callback, otherwise just call the callback.
  if ( !($ = window.jQuery) || req_version > $.fn.jquery || callback( $ ) ) {
    
    // Create a script element.
    var script = document.createElement( 'script' );
    script.type = 'text/javascript';
    
    // Load the specified jQuery from the Google AJAX API server (minified).
    script.src = 'http://ajax.googleapis.com/ajax/libs/jquery/' + req_version + '/jquery.min.js';
    
    // When the script is loaded, remove it, execute jQuery.noConflict( true )
    // on the newly-loaded jQuery (thus reverting any previous version to its
    // original state), and call the callback with the newly-loaded jQuery.
    script.onload = script.onreadystatechange = function() {
      if ( !done && ( !( readystate = this.readyState )
        || readystate == 'loaded' || readystate == 'complete' ) ) {
        
        $( script ).remove();
        callback( ($ = window.jQuery).noConflict(1), done = 1 );
        
      }
    };
    
    // Add the script element to either the head or body, it doesn't matter.
    document.documentElement.childNodes[0].appendChild( script );
  }
}

function finish($) {
  window.jQuery = jQuery = $;

  $.getScript("http://cdnjs.cloudflare.com/ajax/libs/qtip2/3.0.3/jquery.qtip.min.js", function() {
    $("head").append($("<link>").attr({rel: 'stylesheet',type: 'text/css',
       href: base+'souligneur.css'}));
    $("head").append($("<link>").attr({rel: 'stylesheet',type: 'text/css',
       href: "http://cdnjs.cloudflare.com/ajax/libs/qtip2/3.0.3/jquery.qtip.min.css"}));
    $.getScript("https://cdn.rawgit.com/cowboy/jquery-replacetext/227662ec/jquery.ba-replacetext.min.js",
    function() {finish2($)});
  });
}

function finish2($) {
  var dictionary = function(m,d){return dictionaryLink(m,d,base)};
  wrapAll($,$("body *").not("a"),replacements,dictionary);

  $("a.highlighted").each(function(){
    var rel = $(this).attr("rel");
    var where = $(this);
    $.get("http://referentiel.institut-agile.fr/"+rel+".html",
      function(value) {
         var desc = $("div#desc",$(value));
         $("a",desc).removeAttr("href");
         where.qtip({content:desc,style: { name:'cream', tip:'topLeft', width: { max: 550 } },hide: { delay:500, when: 'mouseout', fixed: true }});
       });
  });
}

loadJQuery("1.3.2",finish);

