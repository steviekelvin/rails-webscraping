class TesteController < ApplicationController
  before_action :set_url_site, only: [:car, :notebooks, :smartphones]

  def info
    render json: { success: 'ok', 
    message: 'Rotas disponíveis para consulta de dados do Mercado Livre',
    routes: {
      smartphones: 'GET /smartphones?url_site=https://www.mercadolivre.com.br/...',
      notebooks: 'GET /notebooks?url_site=https://www.mercadolivre.com.br/...',
      car: 'GET /car?url_site=https://www.mercadolivre.com.br/...'
    } }, status: :ok
  end

  def smartphones
    get_data_smartphones_mercado_live
    render_response
  end

  def notebooks
    get_data_notebooks_mercado_live
    render_response
  end

  def car
    get_data_cars_mercado_live
    render_response
  end

  private

  def set_url_site
    @url_site = params.require(:url_site)
  end

  def render_response
    if @dados.present? && @dados[:titulo].present? && @dados[:foto].present?
      render json: { success: 'ok', dados: @dados }, status: :ok
    else
      render json: { success: 'error', dados: { message: 'Dados não localizados' } }, status: :not_found
    end
  end

  def get_data_cars_mercado_live
    require 'nokogiri'
    require 'open-uri'
  
    begin
      doc = Nokogiri::HTML(URI.open(@url_site))
    rescue OpenURI::HTTPError => e
      @dados = nil
      return
    end

    conteudo = {}
    loja = {}
  
    # Extrai informações da tabela
    doc.search('tbody.andes-table__body tr').each do |row|
      key = row.at_css('th div')&.text&.strip&.downcase
      value = row.at_css('td span')&.text&.strip&.downcase
      conteudo[key] = value if key && value
    end
  
    # Extrai informações da loja
    doc.search('ul.ui-vip-seller-profile__list-extra-info div.ui-seller-info__status-info').each do |row|
      key = row.at_css('h3.ui-seller-info__status-info__title')&.text&.strip&.downcase
      value = row.at_css('p.ui-seller-info__status-info__subtitle')&.text&.strip&.downcase
      loja[key] = value if key && value
    end
    
    @dados = {
      titulo: doc.at_css('.ui-pdp-title')&.text&.strip,
      foto: doc.at_css('.ui-pdp-gallery__figure img')&.attr('src'),
      conteudo: conteudo,
      loja: loja
    }
  end
  

  def get_data_notebooks_mercado_live
    require 'nokogiri'
    require 'open-uri'

    begin
      doc = Nokogiri::HTML(URI.open(@url_site))
    rescue OpenURI::HTTPError => e
      @dados = nil
      return
    end

    conteudo = {}
    loja = {}
    
    # Percorre as linhas da tabela e extrai as informações
    doc.search('tbody.andes-table__body').each do |row|
      row.css('tr').each do |row|
        key = row.css('th div')&.text.strip.downcase
        value = row.css('td span')&.text.strip.downcase
        conteudo[key] = value
      end
    end

    doc.search('div.ui-seller-data-header__title-container').each do |row|
      loja['titulo'] =  row.css('span')&.text.strip.downcase
    end
    
    @dados = {
      titulo: doc.at_css('div h1.ui-pdp-title')&.text.strip,
      foto: doc.at_css('.ui-pdp-gallery__figure img')&.attr('src'),
      conteudo: conteudo,
      loja: loja
    }
  end

  def get_data_smartphones_mercado_live
    require 'nokogiri'
    require 'open-uri'

    begin
      doc = Nokogiri::HTML(URI.open(@url_site))
    rescue OpenURI::HTTPError => e
      @dados = nil
      return
    end

    conteudo = {}
    loja = {}

    doc.search('div.ui-vpp-striped-specs__table').each do |row|
      row.search('table tbody tr').each do |row|
        key = row.search('th div')&.text.strip.downcase
        value = row.search('td span')&.text.strip.downcase
        conteudo[key] = value
      end
    end

    doc.search('.ui-seller-data-header__title-container').each do |row|
      loja['titulo'] =  row.search('span')&.text.strip.downcase
    end
    
    @dados = {
      titulo: doc.at_css('div h1.ui-pdp-title')&.text.strip,
      foto: doc.at_css('.ui-pdp-gallery__figure img')&.attr('src'),
      conteudo: conteudo,
      loja: loja
    }
  end
end
