class Article
  include Mongoid::Document
  include Tire::Model::Search
  include Tire::Model::Callbacks
  
  field :title, :type => String
  field :content, :type => String
  field :published_on, :type => Date
  field :filename, :type => String
  field :grid_fs_id, :type => String
  
  mapping do
    puts 'created mapping'
    indexes :title
    indexes :content
    indexes :published_on, :type => 'date'
    indexes :attachment, :type => 'attachment',
                                :fields => {
                                :name       => { :store => 'yes' },
                                :content    => { :store => 'yes' },
                                :title      => { :store => 'yes' },
                                :attachment => { :term_vector => 'with_positions_offsets', :store => 'yes' },
                                :date       => { :store => 'yes' }
                              }
  end
  
  def to_indexed_json
    to_json(:methods => [:attachment])
  end

  def attachment
    grid_fs = Mongoid::GridFS
    f = grid_fs.get(self.grid_fs_id)
    if filename.present?
       Base64.encode64(f.data)
    end
  end
  
  #def search(params)
  #  tire.search do
  #    query {string params[:q]} if params[:q].present?  
  #  end
  #end
end
