require ('phenotypes/catalog_component')

View('Phenotypes.Index', {
  config: {
    components: function () {
      return new Phenotypes.CatalogComponent({ url: this.url })
    }
  }
});