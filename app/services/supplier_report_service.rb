class SupplierReportService
  def initialize(suppliers)
    @suppliers = suppliers
  end

  def generate_pdf
    pdf = Prawn::Document.new
    
    pdf.text "Relatório de Fornecedores", size: 20, style: :bold
    pdf.move_down 20

    @suppliers.each do |supplier|
      pdf.text "Fornecedor: #{supplier.name}", size: 14, style: :bold
      pdf.text "CPF: #{supplier.cpf}"
      pdf.text "Email: #{supplier.email}"
      pdf.text "Endereço: #{format_address(supplier.address)}"
      
      pdf.stroke_horizontal_rule
      pdf.move_down 10
    end

    add_footer(pdf)
    pdf.render
  end

  private

  def format_address(address)
    return "Endereço não cadastrado" unless address
    "#{address[:street]}, #{address[:neighborhood]}, #{address[:city]} - #{address[:state]}"
  end

  def add_footer(pdf)
    pdf.go_to_page(pdf.page_count)
    pdf.move_down 30
    pdf.text "Gerado em: #{Time.current.strftime('%d/%m/%Y %H:%M')}"
    pdf.text "Total de fornecedores: #{@suppliers.count}"
  end
end 