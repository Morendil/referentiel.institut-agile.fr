String.class_eval do
  def indent
    return "            "+self
  end
end

def desc
  'De quoi s\'agit-il?'
end

def syno
  'On l\'appelle �galement...'
end

def abus
  'Erreurs courantes'
end

def histo
  'Origines'
end

def progression
  'Comment s\'am�liorer?'
end

def signes
  'Comment reconnaitre son utilisation?'
end

def benefices
  'Quels b�n�fices en attendre?'
end

def cost
  'Quels co�ts ou investissements faut-il consentir?'
end

def resources
  'O� se renseigner pour en savoir plus? (livres, articles)'
end

def pubs
  'Publications acad�miques et travaux de recherche'
end

def training
  'O� peut-on se former?'
end

def experts
  'Qui peut-on consulter?'
end
