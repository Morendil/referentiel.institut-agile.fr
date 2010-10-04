String.class_eval do
  def indent
    return "            "+self
  end
end

def desc
  'De quoi s\'agit-il?'
end

def syno
  'On l\'appelle également...'
end

def abus
  'Erreurs courantes'
end

def histo
  'Origines'
end

def progression
  'Comment s\'améliorer?'
end

def signes
  'Comment reconnaitre son utilisation?'
end

def benefices
  'Quels bénéfice en attendre?'
end

def resources
  'Où se renseigner pour en savoir plus? (livres, articles)'
end

def pubs
  'Publications académiques et travaux de recherche'
end

def training
  'Où peut-on se former?'
end

def experts
  'Qui peut-on consulter?'
end