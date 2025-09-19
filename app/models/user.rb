class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  # Validações customizadas para melhorar mensagens de erro
  validates :email, presence: { message: "E-mail é obrigatório" },
                   format: { with: URI::MailTo::EMAIL_REGEXP, message: "E-mail deve ter um formato válido" },
                   uniqueness: { message: "Este e-mail já está em uso" }
  
  validates :password, presence: { message: "Senha é obrigatória" },
                      length: { minimum: 6, message: "Senha deve ter pelo menos 6 caracteres" },
                      on: :create
  
  validates :password_confirmation, presence: { message: "Confirmação de senha é obrigatória" },
                                   on: :create

  # Método para validar se as senhas coincidem
  validate :passwords_match, on: :create

  private

  def passwords_match
    return unless password.present? && password_confirmation.present?
    
    if password != password_confirmation
      errors.add(:password_confirmation, "Senhas não coincidem")
    end
  end
end
