module DigitalSignature
  def self.validate_manager_signature(signature_params)
    return false if signature_params[:manager_id].blank? || signature_params[:signature_hash].blank?

    manager = Manager.find_by(id: signature_params[:manager_id])
    return false unless manager

    stored_hash = Digest::SHA256.hexdigest(
      "#{manager.email}#{signature_params[:timestamp]}#{manager.signature_secret}"
    )

    puts "stored_hash: #{stored_hash}"
    puts "signature_params[:signature_hash]: #{signature_params[:signature_hash]}"
    signature_params[:signature_hash] == stored_hash
  end
end 